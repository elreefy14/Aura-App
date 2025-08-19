import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/components/instructor_card.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/controllers/courses/my_course_details.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/view/courses/my_course_details/component/exams.dart';
import 'package:ready_lms/view/courses/my_course_details/component/image_card.dart';
import 'package:ready_lms/view/courses/my_course_details/component/lessons.dart';
import 'package:ready_lms/view/courses/my_course_details/component/quizzes.dart';
import 'package:ready_lms/view/courses/my_course_details/component/review.dart';
import 'package:ready_lms/view/courses/my_course_details/component/video.dart';

import '../../new_course/widget/iframe_card.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer(builder: (context, ref, _) {
          String? fileSystem =
              ref.watch(myCourseDetailsController).currentPlay?.fileSystem;
          Contents? contents =
              ref.watch(myCourseDetailsController).currentPlay?.contents;
          var viewContentProvider =
              ref.watch(myCourseDetailsController).currentPlay?.isViewContent;
          if (fileSystem == FileSystem.video.name) {
            return const Visibility(
              visible: true,
              child: VideoCard(),
            );
          }
          if (fileSystem == FileSystem.audio.name) {
            return const Visibility(
              visible: true,
              child: VideoCard(),
            );
          }
          if (fileSystem == FileSystem.iframe.name) {
            return IframeCard(
              iframeUrl:
                  ref.read(myCourseDetailsController).currentPlay!.fileLink!,
              model: contents,
              isViewContent: viewContentProvider,
            );
          }
          if (fileSystem == FileSystem.document.name) {}
          return ImageCard(
              image:
                  ref.read(myCourseDetailsController).currentPlay!.fileLink!);
        }),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Lessons(),
                const Quizzes(),
                const Exams(),
                Consumer(
                  builder: (context, ref, _) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      child: InstructorCard(
                        model: ref
                            .read(myCourseDetailsController)
                            .courseDetails!
                            .course
                            .instructor,
                      ),
                    );
                  },
                ),
                const ReviewWidgets()
              ],
            ),
          ),
        )
      ],
    );
  }
}
