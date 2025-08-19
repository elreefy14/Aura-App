import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/theme.dart';

class TopNavBarIconButton extends StatelessWidget {
  const TopNavBarIconButton({
    super.key,
    required this.svgPath,
    this.onTap,
    this.svgColor = AppStaticColor.grayColor,
  });
  final String svgPath;
  final Function()? onTap;
  final Color svgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        width: 48.h,
        decoration: BoxDecoration(
          color: colors(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24.h),
        ),
        child: Center(
          child: SizedBox(
            height: 18.h,
            width: 18.h,
            child: SvgPicture.asset(
              svgPath,
              color: colors(context).bodyTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
