#!/usr/bin/env sh
# Vut installer for Linux and macOS.
#
# Detects the platform, downloads the matching release artifact from GitHub,
# verifies its SHA-256, and installs it atomically into $VUT_HOME. No Rust,
# Cargo, C compiler, Git or Node is required.
#
#   install.sh [--version=vX.Y.Z] [--no-path]
#
# Environment: VUT_HOME (default ~/.vut), VUT_VERSION, VUT_REPO.
set -eu

REPO="${VUT_REPO:-duongonix/vut}"
VERSION="${VUT_VERSION:-}"
VUT_HOME="${VUT_HOME:-$HOME/.vut}"
NO_PATH=0

usage() {
  cat <<'EOF'
install.sh - install Vut

  --version=vX.Y.Z   install a specific version (default: latest release)
  --no-path          do not modify shell startup files
  -h, --help         show this help

Environment: VUT_HOME (default ~/.vut), VUT_VERSION, VUT_REPO.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --version=*) VERSION="${arg#*=}" ;;
    --no-path) NO_PATH=1 ;;
    -h | --help) usage; exit 0 ;;
    *)
      echo "unknown argument: $arg" >&2
      usage >&2
      exit 2
      ;;
  esac
done

# --- platform detection -------------------------------------------------
os="$(uname -s)"
arch="$(uname -m)"
is_musl() { ldd /bin/sh 2>/dev/null | grep -qi musl; }
case "$os" in
  Linux)
    case "$arch" in
      x86_64 | amd64)
        if is_musl; then target=x86_64-unknown-linux-musl; else target=x86_64-unknown-linux-gnu; fi
        ;;
      aarch64 | arm64)
        if is_musl; then target=aarch64-unknown-linux-musl; else target=aarch64-unknown-linux-gnu; fi
        ;;
      *)
        echo "unsupported Linux architecture: $arch" >&2
        exit 1
        ;;
    esac
    ;;
  Darwin)
    case "$arch" in
      x86_64) target=x86_64-apple-darwin ;;
      arm64 | aarch64) target=aarch64-apple-darwin ;;
      *)
        echo "unsupported macOS architecture: $arch" >&2
        exit 1
        ;;
    esac
    ;;
  *)
    echo "unsupported operating system: $os" >&2
    exit 1
    ;;
esac

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing required tool: $1" >&2
    exit 1
  }
}
need curl
need tar
need mktemp

# --- version resolution -------------------------------------------------
if [ -z "$VERSION" ]; then
  VERSION="$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" |
    sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"v\{0,1\}\([^"]*\)".*/\1/p' |
    head -n1)"
fi
[ -n "$VERSION" ] || {
  echo "could not resolve the latest Vut version" >&2
  exit 1
}

archive="vut-v${VERSION}-${target}.tar.gz"
base="https://github.com/${REPO}/releases/download/v${VERSION}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Downloading ${archive}..."
curl -fsSL "$base/$archive" -o "$tmp/$archive"
if curl -fsSL "$base/SHA256SUMS" -o "$tmp/SHA256SUMS" 2>/dev/null; then
  expected="$(grep " ${archive}\$" "$tmp/SHA256SUMS" | awk '{print $1}' | head -n1 || true)"
  if [ -n "$expected" ]; then
    if command -v sha256sum >/dev/null 2>&1; then
      actual="$(sha256sum "$tmp/$archive" | awk '{print $1}')"
    else
      actual="$(shasum -a 256 "$tmp/$archive" | awk '{print $1}')"
    fi
    [ "$actual" = "$expected" ] || {
      echo "checksum mismatch for ${archive}" >&2
      exit 1
    }
  fi
fi

# --- extract + verify ---------------------------------------------------
mkdir -p "$tmp/extract"
tar -xzf "$tmp/$archive" -C "$tmp/extract"
[ -f "$tmp/extract/manifest.json" ] || {
  echo "archive is missing manifest.json" >&2
  exit 1
}
grep -q "\"target\": \"${target}\"" "$tmp/extract/manifest.json" || {
  echo "manifest target does not match ${target}" >&2
  exit 1
}
for path in bin/vut lib std; do
  [ -e "$tmp/extract/$path" ] || {
    echo "archive is missing $path" >&2
    exit 1
  }
done

# --- atomic install -----------------------------------------------------
# Distribution-managed entries are replaced; user-managed packages/, config/
# and cache/ are left untouched. A failure restores the previous install.
mkdir -p "$VUT_HOME"
stamp="$$"
managed="bin lib std manifest.json"
for entry in $managed; do
  if [ -e "$VUT_HOME/$entry" ]; then
    mv "$VUT_HOME/$entry" "$VUT_HOME/.backup-$stamp-$entry"
  fi
done
if mv "$tmp/extract/bin" "$VUT_HOME/bin" &&
  mv "$tmp/extract/lib" "$VUT_HOME/lib" &&
  mv "$tmp/extract/std" "$VUT_HOME/std" &&
  mv "$tmp/extract/manifest.json" "$VUT_HOME/manifest.json"; then
  for entry in $managed; do rm -rf "$VUT_HOME/.backup-$stamp-$entry"; done
else
  echo "install failed; restoring the previous installation" >&2
  for entry in $managed; do
    rm -rf "$VUT_HOME/$entry"
    if [ -e "$VUT_HOME/.backup-$stamp-$entry" ]; then
      mv "$VUT_HOME/.backup-$stamp-$entry" "$VUT_HOME/$entry"
    fi
  done
  exit 1
fi
mkdir -p "$VUT_HOME/packages" "$VUT_HOME/cache" "$VUT_HOME/config"

# --- PATH ---------------------------------------------------------------
if [ "$NO_PATH" -eq 0 ]; then
  marker="# >>> vut >>>"
  for rc in "$HOME/.profile" "$HOME/.bashrc" "$HOME/.zshrc"; do
    [ -e "$rc" ] || continue
    if ! grep -qF "$marker" "$rc" 2>/dev/null; then
      printf '\n%s\nexport PATH="%s/bin:$PATH"\n# <<< vut <<<\n' "$marker" "$VUT_HOME" >>"$rc"
    fi
  done
fi

"$VUT_HOME/bin/vut" --version
echo "Installed Vut v${VERSION} (${target}) to ${VUT_HOME}"
if [ "$NO_PATH" -eq 0 ]; then
  echo "Open a new shell, or add ${VUT_HOME}/bin to PATH."
fi
