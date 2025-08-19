import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/courses/my_course_details.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends ConsumerStatefulWidget {
  const VideoCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoCardState();
}

class _VideoCardState extends ConsumerState<VideoCard> {
  @override
  void dispose() {
    super.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    if (context.mounted) {
      _disposeVideoControllers();
    }
  }

  void _disposeVideoControllers() {
    // Dispose the previous video player controllers
    final myCourseDetails = ref.read(myCourseDetailsController);
    myCourseDetails.videoPlayerController?.dispose();
    myCourseDetails.chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = ref.watch(myCourseDetailsController).videoLoading;
    VideoPlayerController? videoPlayerController =
        ref.watch(myCourseDetailsController).videoPlayerController;
    ChewieController? chewieController =
        ref.watch(myCourseDetailsController).chewieController;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
          onTap: () {
            if (chewieController != null) {
              if (videoPlayerController!.value.isPlaying) {
                videoPlayerController.pause();
              } else {
                videoPlayerController.play();
              }
            }

            ref.read(myCourseDetailsController.notifier).updateState();
          },
          child: AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Container(
              color: context.color.surface,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (ref
                          .watch(myCourseDetailsController)
                          .currentPlay
                          ?.fileSystem ==
                      FileSystem.audio.name)
                    FadeInImage.assetNetwork(
                      placeholderFit: BoxFit.contain,
                      placeholder: 'assets/images/spinner.gif',
                      image: ref
                          .watch(myCourseDetailsController)
                          .courseDetails!
                          .course
                          .thumbnail,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: Align(
                      alignment: Alignment.center,
                      child: loading == false &&
                              chewieController != null &&
                              videoPlayerController?.value != null
                          ? Chewie(controller: chewieController)
                          : const CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.nav.pushNamed(Routes.courseNew, arguments: {
              'courseId':
                  ref.watch(myCourseDetailsController).courseDetails?.course.id,
              'show': false
            });
          },
          child: Container(
            color: context.color.surface,
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.h),
            child: Text(
              ref.watch(myCourseDetailsController).currentPlay!.fileName ??
                  "Demo",
              style: AppTextStyle(context)
                  .bodyText
                  .copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
