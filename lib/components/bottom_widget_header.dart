import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class BottomBarHeader extends StatelessWidget {
  const BottomBarHeader(
      {super.key,
      required this.onTap,
      required this.title,
      this.body,
      this.onTapEdit});
  final VoidCallback onTap;
  final String title;
  final String? body;
  final VoidCallback? onTapEdit;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontSize: 22.sp, fontWeight: FontWeight.bold),
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                width: 20.h,
                height: 20.h,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors(context).hintTextColor!.withOpacity(.7)),
                child: Center(
                    child: Icon(
                  Icons.close_rounded,
                  color: context.color.surface,
                  size: 16.h,
                )),
              ),
            )
          ],
        ),
        12.ph,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (body != null)
              Expanded(
                child: Text(
                  body!,
                  style: AppTextStyle(context).bodyTextSmall,
                ),
              ),
            if (onTapEdit != null)
              GestureDetector(
                onTap: onTapEdit,
                child: SvgPicture.asset(
                  'assets/svg/ic_edit.svg',
                  height: 24.h,
                  width: 24.h,
                  color: colors(context).primaryColor,
                ),
              )
          ],
        )
      ],
    );
  }
}
