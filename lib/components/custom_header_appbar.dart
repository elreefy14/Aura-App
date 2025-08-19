import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class CustomHeaderAppBar extends StatelessWidget {
  const CustomHeaderAppBar({
    super.key,
    required this.title,
    this.widget,
    this.onTap,
  });
  final String title;
  final Widget? widget;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
        color: context.color.surface,
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 16.h),
        child: Row(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap ?? () => context.nav.pop(),
              child: SvgPicture.asset(
                'assets/svg/ic_arrow_left.svg',
                width: 24.h,
                height: 24.h,
                color: context.color.onSurface,
              ),
            ),
            12.pw,
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 5.h),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle(context).appBarText,
                ),
              ),
            ),
            widget ?? Container()
          ],
        ));
  }
}
