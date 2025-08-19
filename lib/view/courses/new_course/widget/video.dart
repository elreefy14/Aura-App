import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/controllers/courses/course.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:video_player/video_player.dart';

class VideoCard extends ConsumerStatefulWidget {
  const VideoCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoCardViewState();
}

class _VideoCardViewState extends ConsumerState<VideoCard> {
  void _disposeVideoControllers() {
    // Dispose the previous video player controllers
    final myCourseDetails = ref.read(courseController);
    myCourseDetails.videoPlayerController?.dispose();
    myCourseDetails.chewieController?.dispose();
  }

  @override
  void dispose() {
    super.dispose();
    if (context.mounted) _disposeVideoControllers();
  }

  @override
  Widget build(BuildContext context) {
    bool loading = ref.watch(courseController).videoLoading;
    VideoPlayerController? videoPlayerController =
        ref.watch(courseController).videoPlayerController;
    ChewieController? chewieController =
        ref.watch(courseController).chewieController;
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

            ref.read(courseController.notifier).updateState();
          },
          child: AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: Container(
              color: context.color.surface,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (ref.watch(courseController).currentPlay?.fileSystem ==
                      FileSystem.audio.name)
                    FadeInImage.assetNetwork(
                      placeholderFit: BoxFit.contain,
                      placeholder: 'assets/images/spinner.gif',
                      image: ref
                          .watch(courseController)
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
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: loading == false &&
                  //             chewieController != null &&
                  //             videoPlayerController?.value != null
                  //         ? Chewie(controller: chewieController)
                  //         : const CircularProgressIndicator(),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
