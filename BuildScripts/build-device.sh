#!/bin/bash
# Builds and signs the iPhone app, keeps a copy named with its version, and
# installs it on a connected iPhone when DEVICE_ID is set.
#
#   DEVELOPMENT_TEAM=<team id> DEVICE_ID=<iphone udid> bash BuildScripts/build-device.sh
#
# The team ID and device ID are personal, so they are passed in, never stored here.
set -euo pipefail
cd "$(dirname "$0")/.."

: "${DEVELOPMENT_TEAM:?Set DEVELOPMENT_TEAM to your signing team ID}"
BUNDLE_ID="${BUNDLE_ID:-io.github.hekheler.moonlight-remote}"
DERIVED=Build/DerivedData
destination='generic/platform=iOS'
if [ -n "${DEVICE_ID:-}" ]; then destination="id=$DEVICE_ID"; fi

xcodebuild -project Moonlight.xcodeproj -scheme Moonlight -configuration Debug \
    -destination "$destination" -derivedDataPath "$DERIVED" -allowProvisioningUpdates \
    DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM" PRODUCT_BUNDLE_IDENTIFIER="$BUNDLE_ID" build

app="$DERIVED/Build/Products/Debug-iphoneos/Moonlight.app"
version=$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' "$app/Info.plist")
out=Build/ipa
rm -rf "$out/Payload"
mkdir -p "$out/Payload"
cp -R "$app" "$out/Payload/"
(cd "$out" && rm -f "MoonlightRemote-$version.ipa" && /usr/bin/zip -qry "MoonlightRemote-$version.ipa" Payload && rm -rf Payload)
echo "Saved $out/MoonlightRemote-$version.ipa"

if [ -n "${DEVICE_ID:-}" ]; then
    xcrun devicectl device install app --device "$DEVICE_ID" "$app"
fi
