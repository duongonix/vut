#!/usr/bin/env sh
# Vut installer for Linux and macOS.
#
# Resolves the platform through the release manifest (`releases.json`), downloads
# the matching release artifact from GitHub, verifies its SHA-256, and installs
# it atomically into $VUT_HOME. No Rust, Cargo, C compiler, Git or Node is
# required.
#
#   install.sh [--version=vX.Y.Z] [--no-path] [--provision]
#
# Environment:
#   VUT_HOME              install root (default ~/.vut)
#   VUT_VERSION           install a specific version (default: latest)
#   VUT_REPO              owner/repo hosting releases (default duongonix/vut)
#   VUT_RELEASE_MANIFEST  override the release manifest (URL or local file)
set -eu

REPO="${VUT_REPO:-duongonix/vut}"
VERSION="${VUT_VERSION:-}"
VUT_HOME="${VUT_HOME:-$HOME/.vut}"
NO_PATH=0
PROVISION=0

usage() {
  cat <<'EOF'
install.sh - install Vut

  --version=vX.Y.Z   install a specific version (default: latest release)
  --no-path          do not modify shell startup files
  --provision        attempt official provisioning of missing SDK tools
  -h, --help         show this help

Environment: VUT_HOME, VUT_VERSION, VUT_REPO, VUT_RELEASE_MANIFEST.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --version=*) VERSION="${arg#*=}" ;;
    --no-path) NO_PATH=1 ;;
    --provision) PROVISION=1 ;;
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

# --- release manifest ---------------------------------------------------
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

if [ -n "${VUT_RELEASE_MANIFEST:-}" ]; then
  manifest_source="$VUT_RELEASE_MANIFEST"
elif [ -n "$VERSION" ]; then
  manifest_source="https://github.com/${REPO}/releases/download/v${VERSION}/releases.json"
else
  manifest_source="https://raw.githubusercontent.com/${REPO}/main/releases.json"
fi

download() {
  # download <source> <destination>; supports http(s), file:// and local paths.
  case "$1" in
    http://* | https://* | file://*) curl -fsSL "$1" -o "$2" ;;
    *) cp "$1" "$2" ;;
  esac
}

manifest="$tmp/releases.json"
echo "Fetching release manifest from ${manifest_source}..."
if ! download "$manifest_source" "$manifest"; then
  echo "could not download the release manifest (${manifest_source})" >&2
  exit 1
fi

if [ -z "$VERSION" ]; then
  VERSION="$(sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$manifest" | head -n1)"
fi
[ -n "$VERSION" ] || {
  echo "could not resolve the latest Vut version from the manifest" >&2
  exit 1
}

# Extract the target entry from the manifest without external JSON tooling.
# The manifest is machine-generated with one field per line.
entry="$(awk -v want="$target" '
  /"triple":/ { inside = index($0, "\"" want "\"") > 0; next }
  inside && /"url":/ {
    line = $0; sub(/^.*"url":[[:space:]]*"/, "", line); sub(/".*$/, "", line); url = line
  }
  inside && /"sha256":/ {
    line = $0; sub(/^.*"sha256":[[:space:]]*"/, "", line); sub(/".*$/, "", line); sha = line
  }
  END { if (url != "") print url " " sha }
' "$manifest")"

if [ -z "$entry" ]; then
  echo "the release manifest has no artifact for target ${target}" >&2
  exit 1
fi
url="${entry%% *}"
expected="${entry#* }"
[ -n "$url" ] && [ -n "$expected" ] || {
  echo "the release manifest entry for ${target} is missing its URL or checksum" >&2
  exit 1
}

archive="$(basename "$url")"

# --- download + integrity ----------------------------------------------
echo "Downloading ${archive}..."
download "$url" "$tmp/$archive" || {
  echo "failed to download ${url}" >&2
  exit 1
}

if command -v sha256sum >/dev/null 2>&1; then
  actual="$(sha256sum "$tmp/$archive" | awk '{print $1}')"
elif command -v shasum >/dev/null 2>&1; then
  actual="$(shasum -a 256 "$tmp/$archive" | awk '{print $1}')"
else
  echo "no SHA-256 tool (sha256sum or shasum) is available; cannot verify the download" >&2
  exit 1
fi
if [ "$actual" != "$expected" ]; then
  echo "checksum mismatch for ${archive}" >&2
  echo "  expected: ${expected}" >&2
  echo "  actual:   ${actual}" >&2
  exit 1
fi
echo "Verified SHA-256."

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
managed="bin lib std manifest.json version.json"
for entry in $managed; do
  if [ -e "$VUT_HOME/$entry" ]; then
    mv "$VUT_HOME/$entry" "$VUT_HOME/.backup-$stamp-$entry"
  fi
done
installed=0
if mv "$tmp/extract/bin" "$VUT_HOME/bin" &&
  mv "$tmp/extract/lib" "$VUT_HOME/lib" &&
  mv "$tmp/extract/std" "$VUT_HOME/std" &&
  mv "$tmp/extract/manifest.json" "$VUT_HOME/manifest.json"; then
  [ -f "$tmp/extract/version.json" ] && mv "$tmp/extract/version.json" "$VUT_HOME/version.json"
  [ -f "$tmp/extract/LICENSE" ] && cp "$tmp/extract/LICENSE" "$VUT_HOME/LICENSE"
  [ -f "$tmp/extract/THIRD-PARTY-NOTICES.md" ] && cp "$tmp/extract/THIRD-PARTY-NOTICES.md" "$VUT_HOME/THIRD-PARTY-NOTICES.md"
  # A Vut-managed linker (lld) shipped in `linker/` is placed on the Vut `bin`
  # directory so the resolver finds it without any user setup.
  if [ -d "$tmp/extract/linker" ]; then
    cp -R "$tmp/extract/linker/." "$VUT_HOME/bin/"
  fi
  installed=1
fi
if [ "$installed" -eq 1 ]; then
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
path_configured=0
case ":${PATH:-}:" in
  *":$VUT_HOME/bin:"*) path_configured=1 ;;
esac
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
"$VUT_HOME/bin/vpm" --version
if ! "$VUT_HOME/bin/vut" doctor; then
  echo "warning: Vut could not find a usable linker." >&2
  case "$(uname -s)" in
    Darwin)
      echo "  install the Xcode Command Line Tools: xcode-select --install" >&2
      [ "$PROVISION" -eq 1 ] && echo "  (run the command above to provision them)" >&2
      ;;
    *)
      echo "  install a C toolchain (cc and binutils) with your package manager," >&2
      echo "  or use an archive that ships a Vut-managed linker." >&2
      ;;
  esac
fi
echo "Installed Vut v${VERSION} (${target}) to ${VUT_HOME}"
if [ "$NO_PATH" -eq 0 ] && [ "$path_configured" -eq 0 ]; then
  echo "Open a new shell, or run:"
  echo "  export PATH=\"${VUT_HOME}/bin:\$PATH\""
elif [ "$path_configured" -eq 1 ]; then
  echo "Vut is already on PATH in this shell."
fi
