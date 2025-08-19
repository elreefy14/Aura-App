import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/course_list.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class CertificateCard extends StatelessWidget {
  const CertificateCard({super.key, required this.model, required this.onTap});
  final CourseListModel model;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    bool canDownload = model.isCompleted;
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      color: context.color.surface,
      padding: EdgeInsets.all(20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${S.of(context).certificateOf}: ${model.title}',
              style: AppTextStyle(context)
                  .bodyTextSmall
                  .copyWith(fontWeight: FontWeight.w500)),
          12.ph,
          SizedBox(
            width: double.infinity,
            height: 182.h,
            child: ClipRRect(
              borderRadius: AppComponents.defaultBorderRadiusSmall,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(1),
                    child: ClipRRect(
                      borderRadius: AppComponents.defaultBorderRadiusSmall,
                      child: Image.asset(
                        'assets/images/im_certificate.png',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                      padding: canDownload
                          ? const EdgeInsets.all(1)
                          : EdgeInsets.zero,
                      child: ClipRRect(
                        borderRadius: AppComponents.defaultBorderRadiusSmall,
                        child: buildBlurWidget(
                            context: context, blur: canDownload ? .5 : 4),
                      )),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            canDownload
                                ? 'assets/images/ic_download_certificate.png'
                                : 'assets/images/ic_certificate_lock.png',
                            width: 48.h,
                            height: 48.h,
                          ),
                          16.ph,
                          Text(
                              canDownload
                                  ? S.of(context).unlockCertificate
                                  : S.of(context).lockCertificate,
                              textAlign: TextAlign.center,
                              style: AppTextStyle(context)
                                  .bodyTextSmall
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: AppStaticColor.whiteColor)),
                          if (canDownload) 8.ph,
                          if (canDownload)
                            GestureDetector(
                              onTap: onTap,
                              child: Text(
                                S.of(context).tapToDownload,
                                style: AppTextStyle(context)
                                    .bodyTextSmall
                                    .copyWith(
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            AppStaticColor.whiteColor,
                                        color: AppStaticColor.whiteColor),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                  if (canDownload)
                    Positioned(
                        right: 0,
                        top: 0,
                        child: Image.asset(
                          'assets/images/ic_certificate_checked.png',
                          width: 34.h,
                          height: 34.h,
                          color: context.color.surface,
                        )),
                  if (canDownload)
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        width: 16.h,
                        height: 16.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppStaticColor.greenColor),
                        child: Center(
                          child: Icon(
                            Icons.done_rounded,
                            color: context.color.surface,
                            size: 16.h,
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  buildBlurWidget({required BuildContext context, double blur = 4}) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: context.color.shadow.withOpacity(.75),
          ),
        ),
      ),
    );
  }
}
