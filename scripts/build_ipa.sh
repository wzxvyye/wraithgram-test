#!/usr/bin/env bash
# Собирает НЕПОДПИСАННЫЙ .ipa без Xcode-проекта: swiftc + Info.plist + zip.
# Такой ipa ставится через Sideloadly / AltStore — они сами подписывают его вашим Apple ID.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

APP_NAME="${APP_NAME:-WraithgramTest}"
DISPLAY_NAME="${DISPLAY_NAME:-Wraithgram Test}"
BUNDLE_ID="${BUNDLE_ID:-com.wraithgram.test}"
APP_VERSION="${APP_VERSION:-1.0}"
BUILD_NUMBER="${BUILD_NUMBER:-1}"
MIN_IOS="${MIN_IOS:-16.0}"

OUT_DIR="$ROOT/build"
APP_BUNDLE="$OUT_DIR/Payload/$APP_NAME.app"

echo "==> iOS SDK"
SDK="$(xcrun --sdk iphoneos --show-sdk-path)"
echo "    SDK: $SDK ($(xcrun --sdk iphoneos --show-sdk-version))"

rm -rf "$OUT_DIR"
mkdir -p "$APP_BUNDLE"

echo "==> Компиляция $APP_NAME (arm64, iOS >= $MIN_IOS)"
swiftc \
  -sdk "$SDK" \
  -target "arm64-apple-ios${MIN_IOS}" \
  -O -whole-module-optimization \
  -module-name "$APP_NAME" \
  -o "$APP_BUNDLE/$APP_NAME" \
  "$ROOT/App/Sources/"*.swift

echo "==> Info.plist"
cp "$ROOT/App/Info.plist" "$APP_BUNDLE/Info.plist"
PB=/usr/libexec/PlistBuddy
"$PB" -c "Set :CFBundleExecutable $APP_NAME" "$APP_BUNDLE/Info.plist"
"$PB" -c "Set :CFBundleName $APP_NAME" "$APP_BUNDLE/Info.plist"
"$PB" -c "Set :CFBundleDisplayName $DISPLAY_NAME" "$APP_BUNDLE/Info.plist"
"$PB" -c "Set :CFBundleIdentifier $BUNDLE_ID" "$APP_BUNDLE/Info.plist"
"$PB" -c "Set :CFBundleShortVersionString $APP_VERSION" "$APP_BUNDLE/Info.plist"
"$PB" -c "Set :CFBundleVersion $BUILD_NUMBER" "$APP_BUNDLE/Info.plist"
"$PB" -c "Set :MinimumOSVersion $MIN_IOS" "$APP_BUNDLE/Info.plist"
plutil -lint "$APP_BUNDLE/Info.plist"

if [ -d "$ROOT/App/Icon" ] && compgen -G "$ROOT/App/Icon/*.png" > /dev/null; then
  echo "==> Иконки"
  cp "$ROOT/App/Icon/"*.png "$APP_BUNDLE/"
fi

echo "==> Упаковка ipa"
cd "$OUT_DIR"
rm -f "$APP_NAME.ipa"
zip -qry "$APP_NAME.ipa" Payload
cd "$ROOT"

echo "==> Готово:"
ls -lh "$OUT_DIR/$APP_NAME.ipa"
