#!/bin/bash

# iOS Bundle ID Verification Script
# This script verifies that all iOS configuration files have the correct bundle ID

echo "🔍 Verifying iOS Bundle ID Configuration..."
echo "Expected Bundle ID: com.aurafoundation"
echo ""

# Check for old bundle ID references
echo "❌ Checking for old bundle ID (com.ready.lms)..."
if grep -r "com.ready.lms" . --exclude-dir=.git --exclude="*.sh" --exclude="codemagic.yaml" 2>/dev/null; then
    echo "⚠️  WARNING: Found old bundle ID references!"
    exit 1
else
    echo "✅ No old bundle ID references found"
fi

echo ""

# Check iOS project configuration
echo "📱 Checking iOS project configuration..."
if grep -q "PRODUCT_BUNDLE_IDENTIFIER = com.aurafoundation" ios/Runner.xcodeproj/project.pbxproj; then
    echo "✅ iOS project.pbxproj configured correctly"
else
    echo "❌ iOS project.pbxproj needs bundle ID update"
    exit 1
fi

# Check Firebase configuration
echo "🔥 Checking Firebase configuration..."
if grep -q "iosBundleId: 'com.aurafoundation'" lib/firebase_options.dart; then
    echo "✅ Firebase iOS bundle ID configured correctly"
else
    echo "❌ Firebase configuration needs bundle ID update"
    exit 1
fi

# Check export options
echo "📦 Checking export options..."
if grep -q "com.aurafoundation" ios/export_options.plist; then
    echo "✅ Export options configured correctly"
else
    echo "❌ Export options need bundle ID update"
    exit 1
fi

# Check Codemagic configuration
echo "🏗️ Checking Codemagic configuration..."
if grep -q "bundle_identifier: com.aurafoundation" codemagic.yaml; then
    echo "✅ Codemagic bundle ID configured correctly"
else
    echo "❌ Codemagic configuration needs bundle ID update"
    exit 1
fi

echo ""
echo "🎉 All iOS Bundle ID configurations verified successfully!"
echo ""
echo "📋 Configuration Summary:"
echo "• Bundle ID: com.aurafoundation"
echo "• Signing Style: Manual"
echo "• Export Method: ad-hoc"
echo "• Firebase: Configured ✅"
echo "• iOS Project: Configured ✅"
echo "• Export Options: Configured ✅"
echo "• Codemagic: Configured ✅"
echo ""
echo "🔧 Next Steps for Codemagic:"
echo "1. Create Apple Developer provisioning profile for 'com.aurafoundation'"
echo "2. Upload iOS Distribution certificate to Codemagic"
echo "3. Configure provisioning profile in Codemagic iOS signing settings"
echo "4. Trigger new iOS build with enhanced cleaning"
