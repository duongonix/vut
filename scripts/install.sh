#!/usr/bin/env bash
set -euo pipefail

REPO="duongonix/vut"
VERSION="${VUT_VERSION:-v0.1.1}"

VUT_HOME="${VUT_HOME:-$HOME/.vut}"
INSTALL_DIR="${VUT_INSTALL_DIR:-$VUT_HOME/bin}"

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS" in
  Linux)
    PLATFORM="linux"
    EXT="tar.gz"
    ;;
  Darwin)
    PLATFORM="macos"
    EXT="tar.gz"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    PLATFORM="windows"
    EXT="zip"
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

case "$ARCH" in
  x86_64|amd64)
    ARCH_NAME="x86_64"
    ;;
  arm64|aarch64)
    ARCH_NAME="aarch64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

if [ "$PLATFORM" = "linux" ] && [ "$ARCH_NAME" != "x86_64" ]; then
  echo "Linux $ARCH_NAME is not supported yet"
  exit 1
fi

ASSET="vut-vpm-${PLATFORM}-${ARCH_NAME}.${EXT}"
BASE_URL="https://github.com/${REPO}/releases/download/${VERSION}"
URL="${BASE_URL}/${ASSET}"
SHA_URL="${URL}.sha256"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Installing Vut ${VERSION}"
echo "Platform: ${PLATFORM}-${ARCH_NAME}"
echo "Vut home: ${VUT_HOME}"
echo "Install dir: ${INSTALL_DIR}"
echo ""

echo "Creating Vut home structure..."

mkdir -p "$VUT_HOME/bin"
mkdir -p "$VUT_HOME/std"
mkdir -p "$VUT_HOME/packages"
mkdir -p "$VUT_HOME/cache"
mkdir -p "$VUT_HOME/registry"
mkdir -p "$INSTALL_DIR"

if [ ! -f "$VUT_HOME/config.toml" ]; then
  cat > "$VUT_HOME/config.toml" <<EOF
[global]
home = "$VUT_HOME"

[paths]
bin = "$VUT_HOME/bin"
std = "$VUT_HOME/std"
packages = "$VUT_HOME/packages"
cache = "$VUT_HOME/cache"
registry = "$VUT_HOME/registry"
EOF
fi

cd "$TMP_DIR"

echo "Downloading: ${ASSET}"

if command -v curl >/dev/null 2>&1; then
  curl -fL -o "$ASSET" "$URL"
  curl -fL -o "$ASSET.sha256" "$SHA_URL"
elif command -v wget >/dev/null 2>&1; then
  wget -O "$ASSET" "$URL"
  wget -O "$ASSET.sha256" "$SHA_URL"
else
  echo "curl or wget is required"
  exit 1
fi

echo "Verifying checksum..."

if command -v sha256sum >/dev/null 2>&1; then
  sha256sum -c "$ASSET.sha256"
elif command -v shasum >/dev/null 2>&1; then
  shasum -a 256 -c "$ASSET.sha256"
else
  echo "No checksum tool found, skipping verification"
fi

echo "Extracting..."

if [ "$EXT" = "zip" ]; then
  if command -v unzip >/dev/null 2>&1; then
    unzip -o "$ASSET" -d "$INSTALL_DIR"
  else
    echo "unzip is required for Windows zip package"
    exit 1
  fi
else
  tar -xzf "$ASSET" -C "$INSTALL_DIR"
fi

chmod +x "$INSTALL_DIR/vut" 2>/dev/null || true
chmod +x "$INSTALL_DIR/vpm" 2>/dev/null || true

echo ""
echo "Vut installed successfully."
echo ""
echo "Installed files:"
echo "  $INSTALL_DIR/vut"
echo "  $INSTALL_DIR/vpm"
echo ""
echo "Vut home structure:"
echo "  $VUT_HOME/bin"
echo "  $VUT_HOME/std"
echo "  $VUT_HOME/packages"
echo "  $VUT_HOME/cache"
echo "  $VUT_HOME/registry"
echo "  $VUT_HOME/config.toml"
echo ""

case ":$PATH:" in
  *":$INSTALL_DIR:"*)
    echo "PATH already contains:"
    echo "  $INSTALL_DIR"
    ;;
  *)
    echo "Add this to your shell config:"
    echo ""
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    echo ""
    ;;
esac

echo "Test:"
echo "  vut --version"
echo "  vpm --version"