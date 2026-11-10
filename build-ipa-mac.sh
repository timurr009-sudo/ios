#!/usr/bin/env bash
# Сборка IPA на Mac с Xcode. Запуск: TEAM_ID=XXXXXXXXXX ./build-ipa-mac.sh
set -euo pipefail

: "${TEAM_ID:?Укажите TEAM_ID (Apple Developer → Membership → Team ID)}"
BUNDLE_ID="${BUNDLE_ID:-com.safar.app}"
BUILD_NUMBER="${BUILD_NUMBER:-$(date +%Y%m%d%H%M)}"

npm ci
npx cap sync ios

xcodebuild archive \
  -project ios/App/App.xcodeproj \
  -scheme App \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath build/Safar.xcarchive \
  -allowProvisioningUpdates \
  DEVELOPMENT_TEAM="$TEAM_ID" \
  PRODUCT_BUNDLE_IDENTIFIER="$BUNDLE_ID" \
  CODE_SIGN_STYLE=Automatic \
  CURRENT_PROJECT_VERSION="$BUILD_NUMBER"

sed "s/__TEAM_ID__/$TEAM_ID/" ios/ExportOptions.plist > build/ExportOptions.plist

xcodebuild -exportArchive \
  -archivePath build/Safar.xcarchive \
  -exportPath build/ipa \
  -exportOptionsPlist build/ExportOptions.plist \
  -allowProvisioningUpdates

echo "Готово: $(ls build/ipa/*.ipa)"
