import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/controllers/my_course_tab.dart';
import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/model/current_class.dart';
import 'package:ready_lms/model/hive_mode/hive_cart_model.dart';
import 'package:ready_lms/service/courses/my_course_details.dart';
import 'package:video_player/video_player.dart';

class MyCourseDetailsController extends StateNotifier<MyCourse> {
  final Ref ref;
  MyCourseDetailsController(super.state, this.ref);
  final Box<HiveCartModel> _cartBox = Hive.box<HiveCartModel>(AppHSC.cartBox);
  Future<void> initVideo(String url) async {
    if (mounted) state = state.copyWith(videoLoading: true);
    try {
      // Create new VideoPlayerController
      VideoPlayerController lVideo =
          VideoPlayerController.networkUrl(Uri.parse(url));

      await lVideo.initialize();
      lVideo.setVolume(1.0);
      lVideo.setLooping(false);

      if (mounted) {
        // // Dispose old controllers before assigning new ones
        // state.videoPlayerController?.dispose();
        // state.chewieController?.dispose();

        state = state.copyWith(
            videoPlayerController: lVideo,
            chewieController: ChewieController(
                aspectRatio: 16.0 / 9.0,
                videoPlayerController: lVideo,
                autoPlay: false,
                looping: false,
                showControls: true,
                showOptions: false,
                allowPlaybackSpeedChanging: false));
      }
    } catch (error) {
      state.videoLoading = false;
      print("Video load error: $error");
    } finally {
      if (mounted) {
        state.videoLoading = false;
        state = state._update(state);
      }
    }
  }

  setCurrentIndex(int index) {
    if (mounted) state = state.copyWith(currentIndex: index);
  }

  setCurrentPlay(CurrentPlay currentPlay) {
    // Dispose old video controller if it exists
    state.videoPlayerController?.dispose();
    state.chewieController?.dispose();

    if (mounted) {
      state = state.copyWith(
        currentPlay: currentPlay,
        chewieController: null,
        videoPlayerController: null,
      );
    }
    if (currentPlay.fileSystem == FileSystem.video.name ||
        currentPlay.fileSystem == FileSystem.audio.name) {
      initVideo(currentPlay.fileLink!);
    }
  }

  disposeController() {
    state.videoPlayerController?.dispose();
    state.chewieController?.dispose();
    state = state._update(state);
  }

  getMyCourseDetails(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await ref
          .read(myCourseDetailsServiceProvider)
          .courseDetailByID(id: id);
      state = state.copyWith(isLoading: false);

      if (response.statusCode == 200) {
        var data = CourseDetailModel.fromJson(response.data['data']);
        state = state.copyWith(
            currentPlay: CurrentPlay(
                fileName: data.course.title, fileLink: data.course.thumbnail),
            isLoading: false,
            courseDetails: data);
      }
    } catch (error) {
      debugPrint(error.toString());
      state.courseDetails = null;
    } finally {
      state.isLoading = false;
      state = state._update(state);
    }
  }

  Future<CommonResponse> makeContentView(int id) async {
    bool isSuccess = false;
    try {
      final response = await ref
          .read(myCourseDetailsServiceProvider)
          .makeContentView(id: id);
      state = state.copyWith(isLoading: false);

      if (response.statusCode == 200) {
        isSuccess = true;
      }
      return CommonResponse(
          isSuccess: isSuccess,
          message: response.data['message'],
          response:
              isSuccess ? response.data['data']['content']['is_viewed'] : null);
    } catch (error) {
      debugPrint(error.toString());
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {}
  }

  updateState() {
    state = state._update(state);
  }

  updateReview(int courseID, SubmittedReview data) {
    state.courseDetails!.course.submittedReview =
        SubmittedReview(rating: data.rating, comment: data.comment);
    state.courseDetails!.course.isReviewed = true;
    state = state._update(state);
    ref
        .read(myCourseTabController.notifier)
        .updateListForReview(courseId: courseID, data: data);
  }

  Future<HiveCartModel?> getHiveContent({required int id}) async {
    final cartItems = _cartBox.values.toList();
    if (cartItems.map((e) => e.id).contains(id)) {
      return cartItems.firstWhere((element) => element.id == id);
    } else {
      return null;
    }
  }

  Future<bool> isContentDownloaded({required int id}) async {
    final cartItems = _cartBox.values.toList();
    if (cartItems.map((e) => e.id).contains(id)) {
      return true;
    } else {
      return false;
    }
  }

  addContentToHive(HiveCartModel model) async {
    await _cartBox.add(model);
  }

  updateHiveContent(HiveCartModel model) async {
    final cartItems = _cartBox.values.toList();
    await _cartBox.putAt(
        cartItems.indexWhere((element) => element.id == model.id), model);
  }

  downloadLoading(bool flag) {
    state = state.copyWith(documentDownload: flag);
  }
}

class MyCourse {
  bool isLoading, videoLoading, documentDownload;
  int? currentIndex;
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;
  // VideoPlayerValue? videoPlayerValue;
  CourseDetailModel? courseDetails;
  CurrentPlay? currentPlay;
  MyCourse({
    this.isLoading = false,
    this.videoLoading = false,
    this.currentIndex,
    this.videoPlayerController,
    this.chewieController,
    this.courseDetails,
    this.currentPlay,
    this.documentDownload = false,
    // this.videoPlayerValue
  });
  MyCourse copyWith(
      {isLoading,
      videoLoading,
      currentIndex,
      videoPlayerController,
      chewieController,
      courseDetails,
      currentPlay,
      documentDownload,
      videoPlayerValue}) {
    return MyCourse(
      isLoading: isLoading ?? this.isLoading,
      videoLoading: videoLoading ?? this.videoLoading,
      currentIndex: currentIndex ?? this.currentIndex,
      chewieController: chewieController ?? this.chewieController,
      videoPlayerController:
          videoPlayerController ?? this.videoPlayerController,
      courseDetails: courseDetails ?? this.courseDetails,
      currentPlay: currentPlay ?? this.currentPlay,
      documentDownload: documentDownload ?? this.documentDownload,
      // videoPlayerValue: videoPlayerValue ?? this.videoPlayerValue,
    );
  }

  MyCourse _update(MyCourse state) {
    return MyCourse(
      isLoading: state.isLoading,
      videoLoading: state.videoLoading,
      chewieController: state.chewieController,
      currentIndex: state.currentIndex ?? currentIndex,
      videoPlayerController:
          state.videoPlayerController ?? videoPlayerController,
      courseDetails: state.courseDetails ?? courseDetails,
      currentPlay: state.currentPlay ?? currentPlay,
      documentDownload: state.documentDownload,
      // videoPlayerValue: state.videoPlayerValue ?? this.videoPlayerValue,
    );
  }
}

final myCourseDetailsController =
    StateNotifierProvider.autoDispose<MyCourseDetailsController, MyCourse>(
        (ref) => MyCourseDetailsController(
            MyCourse(
                isLoading: false,
                videoLoading: false,
                currentIndex: -1,
                currentPlay: CurrentPlay(fileSystem: FileSystem.image.name)),
            ref));
