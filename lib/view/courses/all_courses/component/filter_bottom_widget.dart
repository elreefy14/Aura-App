import 'package:ready_lms/components/bottom_widget_header.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/courses/course.dart';
import 'package:ready_lms/controllers/others.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/short_filter.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../components/buttons/app_button.dart';

class FilterBottomWidget extends ConsumerWidget {
  const FilterBottomWidget(this.onTap, {super.key});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context, ref) {
    var courseNotifier = ref.watch(courseController);

    return SingleChildScrollView(
      child: Container(
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
                  title: S.of(context).filter,
                ),
                24.ph,
                Text(
                  S.of(context).rating,
                  style: AppTextStyle(context)
                      .bodyText
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                8.ph,
                Text.rich(
                  TextSpan(
                    children: List.generate(
                        ratingFilterList.length,
                        (index) => WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  ref
                                      .read(courseController.notifier)
                                      .updateFilter(
                                          selectFilterRating:
                                              ratingFilterList[index]);
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: 8.h, bottom: 8.h),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: courseNotifier
                                                      .selectFilterRating!
                                                      .value ==
                                                  ratingFilterList[index].value
                                              ? colors(context).primaryColor!
                                              : colors(context).borderColor!),
                                      borderRadius:
                                          AppComponents.defaultBorderRadiusMini,
                                      color: context.color.surface),
                                  padding: EdgeInsets.all(8.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/ic_star.svg',
                                        height: 20.h,
                                        width: 20.h,
                                      ),
                                      4.pw,
                                      Text(
                                        ratingFilterList[index].name,
                                        style: AppTextStyle(context)
                                            .bodyTextSmall
                                            .copyWith(
                                                color: courseNotifier
                                                            .selectFilterRating!
                                                            .value ==
                                                        ratingFilterList[index]
                                                            .value
                                                    ? colors(context)
                                                        .primaryColor!
                                                    : null,
                                                fontWeight: FontWeight.w600),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  ),
                ),
                // 12.ph,
                // Text(
                //   'Course Instructor',
                //   style: AppTextStyle(context)
                //       .bodyText
                //       .copyWith(fontWeight: FontWeight.w400),
                // ),
                // 8.ph,
                // DropdownButtonFormField<ShortFilter>(
                //   icon: const Icon(Icons.keyboard_arrow_down_sharp),
                //   onChanged: (v) {},
                //   value: shortFilterList[0],
                //   decoration: AppInputDecor.appInputDecor(context),
                //   items: List.generate(
                //       shortFilterList.length,
                //       (index) => DropdownMenuItem(
                //             value: shortFilterList[index],
                //             child: Text(shortFilterList[index].name),
                //           )),
                // ),
                20.ph,
                Row(
                  children: [
                    Text(
                      S.of(context).coursePrice,
                      style: AppTextStyle(context)
                          .bodyText
                          .copyWith(fontWeight: FontWeight.w400),
                    ),
                    const Spacer(),
                    Text(
                      '${AppConstants.currencySymbol}${courseNotifier.selectedFilterRangeValue!.start.round()} - ${AppConstants.currencySymbol}${courseNotifier.selectedFilterRangeValue!.end.round()}',
                      style: AppTextStyle(context).bodyText.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colors(context).primaryColor),
                    ),
                  ],
                ),
                8.ph,
                SliderTheme(
                  data: SliderThemeData(
                    overlayShape: SliderComponentShape.noOverlay,
                    trackHeight: 6.w,
                    trackShape: const RoundedRectSliderTrackShape(),
                  ),
                  child: RangeSlider(
                    values: courseNotifier.selectedFilterRangeValue!,
                    max: ref
                        .read(othersController.notifier)
                        .masterModel!
                        .maxCoursePrice
                        .toDouble(),
                    min: 0,
                    inactiveColor: colors(context).borderColor,
                    onChanged: (RangeValues values) {
                      ref
                          .read(courseController.notifier)
                          .updateFilter(selectedFilterRangeValue: values);
                    },
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${AppConstants.currencySymbol}0',
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: colors(context).hintTextColor),
                    ),
                    const Spacer(),
                    Text(
                      '${AppConstants.currencySymbol}${ref.read(othersController.notifier).masterModel!.maxCoursePrice}',
                      style: AppTextStyle(context).bodyTextSmall.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: colors(context).hintTextColor),
                    ),
                  ],
                ),
                24.ph,
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        title: S.of(context).reset,
                        titleColor: AppStaticColor.redColor,
                        buttonColor: colors(context).scaffoldBackgroundColor,
                        textPaddingVertical: 16.h,
                        onTap: () {
                          ref.read(courseController.notifier).resetFilter();
                          onTap();
                        },
                      ),
                    ),
                    12.pw,
                    Expanded(
                      child: AppButton(
                        title: S.of(context).apply,
                        titleColor: context.color.surface,
                        textPaddingVertical: 16.h,
                        onTap: () {
                          ref.read(courseController.notifier).makeFilterTrue();
                          onTap();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
