#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
NATIVE="$ROOT/native"
DIST="$ROOT/dist"
APP="$DIST/PixelVault.app"
BIN="$APP/Contents/MacOS/PixelVault"

echo "→ Cleaning $DIST"
rm -rf "$DIST"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

echo "→ Compiling native SpriteKit app"
# shellcheck disable=SC2046
swiftc -O \
  -framework Cocoa \
  -framework SpriteKit \
  -framework AppKit \
  $(find "$NATIVE/Sources" -name '*.swift' | sort) \
  -o "$BIN"

cp "$NATIVE/Info.plist" "$APP/Contents/Info.plist"
chmod +x "$BIN"

echo "✓ Built: $APP"
echo "  Launch: open \"$APP\""
