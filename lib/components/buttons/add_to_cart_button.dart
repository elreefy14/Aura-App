import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/theme.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.size,
    required this.onTap,
  });
  final double size;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.h,
        width: size.h,
        decoration: BoxDecoration(
          color: colors(context).primaryColor,
          borderRadius: BorderRadius.circular(size.r),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: AppStaticColor.whiteColor,
            size: (size / 1.3).r,
          ),
        ),
      ),
    );
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.size,
    this.iconColor = AppStaticColor.whiteColor,
    this.btnColor = AppStaticColor.primaryColor,
    required this.iconData,
    this.onTap,
  });
  final double size;
  final Color iconColor;
  final Color btnColor;
  final IconData iconData;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size.h,
        width: size.h,
        decoration: BoxDecoration(
          color: btnColor,
          borderRadius: BorderRadius.circular(size.r),
        ),
        child: Center(
          child: Icon(
            iconData,
            color: iconColor,
            size: (size / 1.3).r,
          ),
        ),
      ),
    );
  }
}
