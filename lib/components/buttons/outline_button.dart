import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    super.key,
    this.width = double.infinity,
    this.buttonColor,
    required this.title,
    this.onTap,
    this.titleColor,
    this.icon,
    this.borderRadius,
    this.textPaddingHorizontal,
    this.textPaddingVertical,
    this.fontSize,
    this.fontWeight,
  });
  final double? width;
  final double? textPaddingHorizontal, textPaddingVertical, fontSize;
  final double? borderRadius;
  final Color? buttonColor;
  final String title;
  final Color? titleColor;
  final FontWeight? fontWeight;
  final Function()? onTap;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
            horizontal: textPaddingHorizontal ?? 16.h,
            vertical: textPaddingVertical ?? 12.h),
        decoration: BoxDecoration(
            color: buttonColor ?? context.color.surface,
            borderRadius: BorderRadius.circular(borderRadius ?? 48.h),
            border: Border.all(color: titleColor ?? context.color.primary)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: textStyle.bodyText.copyWith(
                  fontWeight: fontWeight ?? FontWeight.w700,
                  color: titleColor ?? context.color.primary,
                  fontSize: fontSize),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (icon != null) 8.pw,
            icon != null ? icon! : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
