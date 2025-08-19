import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_input_decor.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/courses/course.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/short_filter.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SortByBottomWidget extends ConsumerWidget {
  const SortByBottomWidget(this.onTap, {super.key});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context, ref) {
    var courseNotifier = ref.watch(courseController);
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
                title: S.of(context).sortBy,
              ),
              24.ph,
              Text(
                S.of(context).coursePrice,
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              8.ph,
              DropdownButtonFormField<ShortFilter>(
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                onChanged: (v) {
                  ref
                      .read(courseController.notifier)
                      .updateSort(selectedShortCourseFee: v);
                  onTap();
                },
                value: courseNotifier.selectedShortCourseFee,
                decoration: AppInputDecor.appInputDecor(context),
                items: List.generate(
                    shortFilterList.length,
                    (index) => DropdownMenuItem(
                          value: shortFilterList[index],
                          child: Text(shortFilterList[index].name!),
                        )),
              ),
              20.ph,
              Text(
                S.of(context).rating,
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.w400),
              ),
              8.ph,
              DropdownButtonFormField<ShortFilter>(
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                onChanged: (v) {
                  ref
                      .read(courseController.notifier)
                      .updateSort(selectedShortRating: v);
                  onTap();
                },
                value: courseNotifier.selectedShortRating,
                decoration: AppInputDecor.appInputDecor(context),
                items: List.generate(
                    shortFilterList.length,
                    (index) => DropdownMenuItem(
                          value: shortFilterList[index],
                          child: Text(shortFilterList[index].name!),
                        )),
              ),
              20.ph,
              Container(
                padding: EdgeInsets.fromLTRB(12.h, 12.h, 4.h, 4.h),
                decoration: BoxDecoration(
                    borderRadius: AppComponents.defaultBorderRadiusMini,
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: Text.rich(
                  TextSpan(
                    children: List.generate(
                        shortBasicFilterList.length,
                        (index) => WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  ref
                                      .read(courseController.notifier)
                                      .updateSort(
                                          selectedShortBasic:
                                              shortBasicFilterList[index]);
                                  onTap();
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 8.h, bottom: 8.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: courseNotifier
                                                      .selectedShortBasic!
                                                      .value ==
                                                  shortBasicFilterList[index]
                                                      .value
                                              ? colors(context).primaryColor!
                                              : colors(context).borderColor!),
                                      borderRadius:
                                          AppComponents.defaultBorderRadiusMini,
                                      color: context.color.surface),
                                  padding: EdgeInsets.all(8.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<ShortFilter>(
                                        value: shortBasicFilterList[index],
                                        groupValue:
                                            courseNotifier.selectedShortBasic,
                                        onChanged: (v) {
                                          ref
                                              .read(courseController.notifier)
                                              .updateSort(
                                                  selectedShortBasic: v);
                                        },
                                        fillColor:
                                            WidgetStateProperty.resolveWith(
                                                (states) {
                                          // active
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return context.color.primary;
                                          }
                                          // inactive
                                          return colors(context)
                                              .hintTextColor!
                                              .withOpacity(AppConstants
                                                  .hintColorBorderOpacity);
                                        }),
                                        visualDensity: const VisualDensity(
                                            horizontal:
                                                VisualDensity.minimumDensity,
                                            vertical:
                                                VisualDensity.minimumDensity),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      6.pw,
                                      Text(shortBasicFilterList[index].name)
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
