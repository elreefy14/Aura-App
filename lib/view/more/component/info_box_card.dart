import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/notification.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class InfoBoxCard extends StatelessWidget {
  const InfoBoxCard({
    super.key,
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    this.showNotification = false,
  });
  final String icon, title;
  final Color color;
  final bool showNotification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.h),
        decoration: BoxDecoration(
            borderRadius: AppComponents.defaultBorderRadiusLarge,
            color: color.withOpacity(.17)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.h),
                  child: SvgPicture.asset(
                    icon,
                    color: color,
                  ),
                ),
                if (showNotification)
                  Consumer(
                    builder: (context, ref, _) {
                      final notificationState = ref.watch(notificationProvider);

                      return notificationState.maybeWhen(
                        data: (data) {
                          int unReadMessage = ref
                              .read(notificationProvider.notifier)
                              .unReadCount();
                          return Positioned(
                            right: 6.h,
                            top: 5.h,
                            child: Container(
                              width: 16.h,
                              height: 16.h,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: context.color.surface,
                                      width: 1.2.h),
                                  shape: BoxShape.circle,
                                  color: AppStaticColor.redColor),
                              child: Center(
                                child: Text(
                                  unReadMessage > 9
                                      ? '$unReadMessage+'
                                      : unReadMessage.toString(),
                                  style: AppTextStyle(context)
                                      .bodyTextSmall
                                      .copyWith(
                                          color: context.color.surface,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 8.sp),
                                ),
                              ),
                            ),
                          );
                        },
                        orElse: () => Container(),
                      );
                    },
                  )
              ],
            ),
            12.ph,
            Text(
              title,
              style: AppTextStyle(context).bodyText.copyWith(),
            ),
          ],
        ),
      ),
    ));
  }
}
