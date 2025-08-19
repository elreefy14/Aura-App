import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/courses/my_course_details.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.image});
  final String image;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer(builder: (context, ref, _) {
          return AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: FadeInImage.assetNetwork(
              placeholderFit: BoxFit.contain,
              placeholder: 'assets/images/spinner.gif',
              image: image,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, color: context.color.primary);
              },
            ),
          );
        }),
        Consumer(builder: (context, ref, _) {
          return ref.watch(myCourseDetailsController).currentPlay!.fileName ==
                  null
              ? Container()
              : GestureDetector(
                  onTap: () {
                    context.nav.pushNamed(Routes.courseNew, arguments: {
                      'courseId': ref
                          .watch(myCourseDetailsController)
                          .courseDetails
                          ?.course
                          .id,
                      'show': false
                    });
                  },
                  child: Container(
                    color: context.color.surface,
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.h),
                    child: Text(
                      ref
                              .watch(myCourseDetailsController)
                              .currentPlay!
                              .fileName ??
                          '',
                      style: AppTextStyle(context)
                          .bodyText
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                );
        }),
      ],
    );
  }
}
