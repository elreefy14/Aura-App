import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DropDownItem extends StatelessWidget {
  const DropDownItem({
    super.key,
    required this.onTap,
    required this.title,
    this.isTopItem = false,
    this.isBottomItem = false,
    required this.isSelected,
  });
  final VoidCallback onTap;
  final String title;
  final bool? isTopItem, isBottomItem;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTopItem! ? 8.r : 0),
          topRight: Radius.circular(isTopItem! ? 8.r : 0),
          bottomLeft: Radius.circular(isBottomItem! ? 8.r : 0),
          bottomRight: Radius.circular(isBottomItem! ? 8.r : 0),
        ),
        color: context.color.surface,
      ),
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: ListTile(
        onTap: onTap,
        title: Text(
          title,
          style: AppTextStyle(context).bodyTextSmall.copyWith(
              color: isSelected ? colors(context).primaryColor : null),
        ),
      ),
    );
  }
}
