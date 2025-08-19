import 'dart:io' show Platform;

import 'package:package_info_plus/package_info_plus.dart';

/// Utilities for In-App Purchase product identifiers.
class IapUtils {
  /// Generate a deterministic Apple product ID for a course.
  ///
  /// Default format: <bundleId>.course.<courseId>
  /// Example: com.yourorg.aura.course.101
  static Future<String> defaultAppleProductIdForCourse(
    int courseId, {
    String? customPrefix,
  }) async {
    // Use bundle identifier if available; fallback to provided prefix or a generic one.
    String prefix = customPrefix ?? 'com.aura.app';
    try {
      if (Platform.isIOS) {
        final info = await PackageInfo.fromPlatform();
        // On iOS, packageName is the bundle identifier.
        if (info.packageName.isNotEmpty) {
          prefix = info.packageName;
        }
      }
    } catch (_) {
      // Ignore and use fallback prefix.
    }
    return '$prefix.course.$courseId';
  }
}
