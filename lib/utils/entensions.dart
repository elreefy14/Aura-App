import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//converts
extension NumModifier on num {
  Duration get miliSec {
    return Duration(milliseconds: int.parse(toString()));
  }

  /// Puts A Vertical Spacer With the value
  SizedBox get ph {
    return SizedBox(
      height: toDouble().h,
    );
  }

  /// Puts A Horizontal Spacer With the value
  SizedBox get pw {
    return SizedBox(
      width: toDouble().w,
    );
  }
}

extension StringExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}
