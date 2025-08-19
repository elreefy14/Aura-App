import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/courses/my_course_details.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/view/courses/new_course/widget/couse_details.dart';

class ContentDetailBottomWidget extends StatelessWidget {
  const ContentDetailBottomWidget({
    super.key,
    required this.model,
    required this.onTap,
    required this.downloadPercentage,
    required this.closeSheet,
  });
  final Contents model;
  final VoidCallback onTap;
  final VoidCallback closeSheet;
  final StateProvider<String> downloadPercentage;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BottomBarHeader(
                  onTap: () {
                    context.nav.pop();
                  },
                  title: S.of(context).fileInfo,
                  body: S.of(context).fileDes),
              32.ph,
              Text(
                'File name : ${model.title}',
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                      fontSize: 12.sp,
                    ),
              ),
              16.ph,
              Row(
                children: [
                  CourseContaintInfoCard(text: 'File type : ${model.type}'),
                  CourseContaintInfoCard(
                      text: 'File ext : ${model.fileExtension}')
                ],
              ),
              16.ph,
              Row(
                children: [
                  Text(
                    'Last Update : ${model.mediaUpdatedAt}',
                    style: AppTextStyle(context).bodyTextSmall.copyWith(
                          fontSize: 12.sp,
                        ),
                  ),
                  const Spacer(),
                  Consumer(builder: (context, ref, _) {
                    if (ref.watch(downloadPercentage).contains('100')) {
                      closeSheet();
                    }
                    return Text(
                      ref.watch(downloadPercentage),
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: colors(context).hintTextColor),
                    );
                  }),
                ],
              ),
              16.ph,
              Row(
                children: [
                  Expanded(
                      child: AppOutlineButton(
                    title: S.of(context).cancel,
                    width: double.infinity,
                    buttonColor: context.color.surface,
                    titleColor: AppStaticColor.redColor,
                    textPaddingVertical: 16.h,
                    borderRadius: 12.r,
                    onTap: () => context.nav.pop(),
                  )),
                  12.pw,
                  Expanded(child: Consumer(builder: (context, ref, _) {
                    return Consumer(builder: (context, ref, _) {
                      return AppButton(
                        title: S.of(context).download,
                        width: double.infinity,
                        showLoading: ref
                            .watch(myCourseDetailsController)
                            .documentDownload,
                        buttonColor: colors(context).primaryColor,
                        titleColor: context.color.surface,
                        textPaddingVertical: 16.h,
                        onTap: onTap,
                      );
                    });
                  })),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
