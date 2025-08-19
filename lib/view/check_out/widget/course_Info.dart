import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/custom_dot.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/checkout.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

import '../../../utils/global_function.dart';

class CourseInfo extends ConsumerWidget {
  const CourseInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    String? image = ref
        .read(checkoutController)
        .courseDetails
        ?.course
        .instructor
        .profilePicture;
    return Container(
      padding: EdgeInsets.all(20.h),
      color: context.color.surface,
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.h),
                child: FadeInImage.assetNetwork(
                  placeholderFit: BoxFit.contain,
                  placeholder: 'assets/images/spinner.gif',
                  image: ref
                          .read(checkoutController)
                          .courseDetails
                          ?.course
                          .thumbnail ??
                      AppConstants.defaultAvatarImageUrl,
                  width: 84.h,
                  height: 42.h,
                  fit: BoxFit.cover,
                ),
              ),
              12.pw,
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref.read(checkoutController).courseDetails?.course.title ??
                        'Demo',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle(context).bodyTextSmall,
                  ),
                  8.ph,
                  Row(
                    children: [
                      Container(
                        width: 16.h,
                        height: 16.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.h),
                          child: image == null
                              ? Center(
                                  child: Image.asset(
                                    'assets/images/im_demo_user_1.png',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/spinner.gif',
                                  image: image,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      6.pw,
                      Expanded(
                        child: Text(
                          'Rob Sutcliffe',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle(context).bodyTextSmall.copyWith(
                              color: context.color.inverseSurface,
                              fontSize: 12.sp),
                        ),
                      ),
                    ],
                  )
                ],
              ))
            ],
          ),
          13.ph,
          Row(
            children: [
              const CustomDot(),
              8.pw,
              Text(
                ApGlobalFunctions.convertMinutesToHours(
                    ref
                            .read(checkoutController)
                            .courseDetails
                            ?.course
                            .totalDuration ??
                        0,
                    context),
                //'${(ref.watch(checkoutController).courseDetails!.course.totalDuration / 60).toStringAsFixed(0)} ${S.of(context).hours}',
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                    color: context.color.inverseSurface, fontSize: 10.sp),
              ),
              8.pw,
              const CustomDot(),
              8.pw,
              Text(
                '${ref.watch(checkoutController).courseDetails?.course.videoCount} ${S.of(context).video}',
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                    color: context.color.inverseSurface, fontSize: 10.sp),
              ),
              8.pw,
              const CustomDot(),
              8.pw,
              Text(
                S.of(context).lifetimeAccess,
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                    color: context.color.inverseSurface, fontSize: 10.sp),
              ),
            ],
          )
        ],
      ),
    );
  }
}
