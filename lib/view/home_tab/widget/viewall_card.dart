import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

class ViewAllCard extends StatelessWidget {
  const ViewAllCard({
    super.key,
    this.padding = 16,
    required this.title,
    this.showViewAll = true,
    this.onTap,
  });

  final double padding;
  final String title;
  final bool showViewAll;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding.h),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyle(context)
                .bodyText
                .copyWith(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          if (showViewAll)
            GestureDetector(
              onTap: onTap,
              child: Text(
                S.of(context).viewAll,
                style: AppTextStyle(context)
                    .bodyTextSmall
                    .copyWith(color: context.color.primary),
              ),
            ),
        ],
      ),
    );
  }
}
