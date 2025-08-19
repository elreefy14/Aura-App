#!/bin/bash

# iOS Build Script for Aura Foundation App
# This script builds the iOS app with proper signing configuration

echo "🚀 Building iOS app for Aura Foundation..."
echo "Bundle ID: com.aurafoundation"
echo "Export Method: ad-hoc"
echo "Signing Style: Manual"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Build iOS app
echo "📱 Building iOS IPA..."
flutter build ipa --release \
  --build-name=1.0.0 \
  --build-number=$(date +%s) \
  --export-options-plist=ios/export_options.plist

echo "✅ Build completed!"
echo "📁 IPA file location: build/ios/ipa/"
echo ""
echo "📋 Next Steps for Codemagic:"
echo "1. Add your Apple Developer Team ID to the export_options.plist"
echo "2. Create an ad-hoc provisioning profile for 'com.aurafoundation'"
echo "3. Upload your iOS Distribution certificate to Codemagic"
echo "4. Configure the provisioning profile in Codemagic settings"
echo ""
echo "🔧 Required Apple Developer Account Setup:"
echo "- Bundle ID: com.aurafoundation"
echo "- Provisioning Profile: iOS Ad Hoc Distribution"
echo "- Certificate: iOS Distribution Certificate"
