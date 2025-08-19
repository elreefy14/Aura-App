import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.width = double.infinity,
    this.height,
    this.buttonColor,
    required this.title,
    this.onTap,
    this.titleColor,
    this.textPaddingHorizontal,
    this.textPaddingVertical,
    this.icon,
    this.showLoading = false,
  });
  final double? width;
  final double? height, textPaddingHorizontal, textPaddingVertical;
  final Color? buttonColor;
  final String title;
  final Color? titleColor;
  final Widget? icon;
  final bool? showLoading;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return FilledButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? colors(context).primaryColor,
        disabledBackgroundColor: buttonColor?.withOpacity(.2) ??
            colors(context).primaryColor?.withOpacity(.2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.h))),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: textPaddingHorizontal ?? 0.h,
              vertical: textPaddingVertical ?? 0.h),
          child: showLoading!
              ? SizedBox(
                  width: 18.h,
                  height: 18.h,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(context.color.surface),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: textStyle.bodyTextSmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? colors(context).bodyTextColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (icon != null) 8.pw,
                    icon != null ? icon! : const SizedBox(),
                  ],
                ),
        ),
      ),
    );
  }
}

class AppTextShrinkButton extends StatelessWidget {
  const AppTextShrinkButton({
    super.key,
    this.buttonColor,
    required this.title,
    this.onTap,
    this.titleColor,
  });

  final Color? buttonColor;
  final String title;
  final Color? titleColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: buttonColor ?? AppStaticColor.primaryColor,
          borderRadius: BorderRadius.circular(30.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: textStyle.bodyText.copyWith(
                fontWeight: FontWeight.bold,
                color: titleColor ?? AppStaticColor.whiteColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            5.pw,
            Icon(
              Icons.arrow_forward_ios,
              size: 20.r,
              color: titleColor ?? AppStaticColor.whiteColor,
            )
          ],
        ),
      ),
    );
  }
}
