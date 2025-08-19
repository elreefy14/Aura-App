import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class InstructorCard extends StatelessWidget {
  const InstructorCard({
    super.key,
    required this.model,
  });
  final Instructor model;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.h),
      decoration: BoxDecoration(
          color: context.color.surface,
          borderRadius: AppComponents.defaultBorderRadiusSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.of(context).courseInstructor,
            style: AppTextStyle(context)
                .bodyTextSmall
                .copyWith(fontSize: 12.sp, color: context.color.primary),
          ),
          7.ph,
          Row(
            children: [
              Container(
                width: 36.h,
                height: 36.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.h),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/spinner.gif',
                    image: model.profilePicture,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              8.pw,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: AppTextStyle(context).bodyTextSmall,
                    ),
                    Text(
                      model.title,
                      maxLines: 2,
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                            fontSize: 10.sp,
                          ),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
