import 'package:ready_lms/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDot extends StatelessWidget {
  const CustomDot({
    super.key,
    this.color,
    this.size = 4,
  });
  final Color? color;
  final double size;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.h,
      height: size.h,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? colors(context).hintTextColor!.withOpacity(.4)),
    );
  }
}
