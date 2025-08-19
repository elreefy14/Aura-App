import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/model/course_list.dart';
import 'package:ready_lms/model/current_class.dart';
import 'package:ready_lms/model/short_filter.dart';
import 'package:ready_lms/service/courses/course.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:video_player/video_player.dart';

class CourseController extends StateNotifier<Course> {
  final Ref ref;

  CourseController(super.state, this.ref);

  removeListData() {
    state.mostPopular.clear();

    state.courseList.clear();

    state = state._update(state);
  }

  Future<void> initVideo(String url) async {
    state = state.copyWith(videoLoading: true);

    try {
      VideoPlayerController lVideo =
          VideoPlayerController.networkUrl(Uri.parse(url));

      await lVideo.initialize();

      lVideo.setVolume(1.0);

      lVideo.setLooping(false);

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
    } catch (error) {
      state.videoLoading = false;
    } finally {
      state.videoLoading = false;

      state = state._update(state);
    }
  }

  void setCurrentPlay(CurrentPlay currentPlay) {
    // Dispose old video controller if it exists
    state.videoPlayerController?.dispose();
    state.chewieController?.dispose();

    if (mounted) {
      state = state.copyWith(currentPlay: currentPlay, chewieController: null);
    }
    if (currentPlay.fileSystem == FileSystem.video.name ||
        currentPlay.fileSystem == FileSystem.audio.name) {
      initVideo(currentPlay.fileLink!);
    }
  }

  getHomeTabInit() async {
    state = state.copyWith(isListLoading: true);

    try {
      final responsePopular = await ref
          .read(courseServiceProvider)
          .courseList(query: {'sort': 'view_count'});

      final response =
          await ref.read(courseServiceProvider).courseList(query: null);

      state = state.copyWith(isListLoading: false);

      final List<dynamic> responsePopularList =
          responsePopular.data['data']['courses'];

      final List<dynamic> responseList = response.data['data']['courses'];

      state.mostPopular = responsePopularList
          .map((data) => CourseListModel.fromJson(data))
          .toList();

      state.courseList =
          responseList.map((data) => CourseListModel.fromJson(data)).toList();

      state.totalCourse = response.data['data']['total_courses'];

      state = state._update(state);
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      state = state.copyWith(isListLoading: false);
    }
  }

  removeAllCourse() {
    state.courseList.clear();

    state = state._update(state);
  }

  Future<CommonResponse> getAllCourse(
      {bool isRefresh = false,
      required int currentPage,
      int parPage = 10,
      bool makeSortOrFiler = true,
      Map<String, dynamic>? query}) async {
    if (isRefresh) {
      state.isListLoading = true;

      state.courseList.clear();

      state = state._update(state);
    }

    bool isSuccess = false;

    bool hasData = false;

    try {
      var map = {
        AppConstants.perPage: parPage,
        AppConstants.page: currentPage,
        if (query != null) ...query,
        if (makeSortOrFiler) ..._getTheFilterAndSortValue()
      };
      final response =
          await ref.read(courseServiceProvider).courseList(query: map);

      if (response.statusCode == 200) {
        isSuccess = true;

        final List<dynamic> responseList = response.data['data']['courses'];

        List<CourseListModel> list =
            responseList.map((data) => CourseListModel.fromJson(data)).toList();

        if (list.isNotEmpty) {
          state.courseList.addAll(list);

          hasData = true;
        }

        state = state._update(state);
      }

      return CommonResponse(
          isSuccess: isSuccess,
          message: response.data['message'],
          response: hasData);
    } catch (error) {
      debugPrint(error.toString());

      return CommonResponse(
          isSuccess: isSuccess, message: error.toString(), response: hasData);
    } finally {
      if (mounted) state = state.copyWith(isListLoading: false);
    }
  }

  getNewCourseDetails(int id) async {
    state = state.copyWith(isLoading: true);

    try {
      final response =
          await ref.read(courseServiceProvider).courseDetailByID(id: id);

      state.courseDetails = CourseDetailModel.fromJson(response.data['data']);

      state.isFavourite = state.courseDetails!.course.isFavourite;

      state = state._update(state);
      state = state.copyWith(
        currentPlay: CurrentPlay(
          fileName: state.courseDetails!.course.title,
          fileLink: state.courseDetails!.course.video ??
              state.courseDetails!.course.thumbnail,
          fileSystem: state.courseDetails!.course.video != null
              ? FileSystem.video.name
              : FileSystem.image.name,
        ),
        isLoading: false,
        courseDetails: state.courseDetails,
      );
      if (state.courseDetails!.course.video != null) {
        initVideo(state.courseDetails!.course.video!);
      }
    } catch (error) {
      debugPrint(error.toString());

      state.courseDetails = null;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  updateFavouriteItem() {
    state = state.copyWith(isFavourite: !state.isFavourite);
  }

  updateSort({
    ShortFilter? selectedShortCourseFee,
    ShortFilter? selectedShortRating,
    ShortFilter? selectedShortBasic,
  }) {
    state = state.copyWith(
        selectedShortCourseFee: selectedShortCourseFee ?? shortFilterList[0],
        selectedShortRating: selectedShortRating ?? shortFilterList[0],
        selectedShortBasic: selectedShortBasic ?? shortBasicFilterList[3]);
  }

  updateFilter({
    ShortFilter? selectFilterRating,
    RangeValues? selectedFilterRangeValue,
  }) {
    state = state.copyWith(
      selectFilterRating: selectFilterRating,
      selectedFilterRangeValue: selectedFilterRangeValue,
    );
  }

  resetFilter() {
    state = state.copyWith(
        isFiltered: false,
        selectFilterRating: ratingFilterList[0],
        selectedFilterRangeValue: const RangeValues(50, 500));
  }

  makeFilterTrue() {
    state = state.copyWith(
      isFiltered: true,
    );
  }

  Map<String, dynamic> _getTheFilterAndSortValue() {
    Map<String, dynamic> map = {};

    if (state.selectedShortCourseFee?.value != '') {
      map['sort'] = 'price';

      map['sortDirection'] = state.selectedShortCourseFee!.value;
    } else if (state.selectedShortRating?.value != '') {
      map['sort'] = 'average_rating';

      map['sortDirection'] = state.selectedShortRating!.value;
    } else if (state.selectedShortBasic?.value != '') {
      map['sort'] = state.selectedShortBasic!.value;
    }

    if (state.isFiltered) {
      map['average_rating'] = state.selectFilterRating?.value;

      map['price_from'] = state.selectedFilterRangeValue?.start;

      map['price_to'] = state.selectedFilterRangeValue?.end;
    }

    return map;
  }

  updateState() {
    state = state._update(state);
  }
}

class Course {
  bool isListLoading, isLoading, isFavourite, isFiltered, videoLoading;

  int totalCourse;

  ChewieController? chewieController;

  VideoPlayerController? videoPlayerController;

  ShortFilter? selectedShortCourseFee,
      selectedShortRating,
      selectedShortBasic,
      selectFilterRating;

  RangeValues? selectedFilterRangeValue;

  List<CourseListModel> courseList, mostPopular;

  CourseDetailModel? courseDetails;
  CurrentPlay? currentPlay;

  Course({
    this.isLoading = false,
    this.isListLoading = false,
    this.videoLoading = false,
    this.isFavourite = false,
    this.isFiltered = false,
    this.totalCourse = 0,
    this.videoPlayerController,
    this.chewieController,
    required this.courseList,
    required this.mostPopular,
    this.courseDetails,
    this.selectedShortRating,
    this.selectedShortBasic,
    this.selectedShortCourseFee,
    this.selectFilterRating,
    this.selectedFilterRangeValue,
    this.currentPlay,
  });

  Course copyWith({
    isLoading,
    isListLoading,
    isFavourite,
    videoLoading,
    totalCourse,
    isFiltered,
    videoPlayerController,
    chewieController,
    courseList,
    mostPopular,
    enrollCourseList,
    courseDetails,
    selectedShortRating,
    selectedShortBasic,
    selectedShortCourseFee,
    selectFilterRating,
    selectedFilterRangeValue,
    currentPlay,
  }) {
    return Course(
      isLoading: isLoading ?? this.isLoading,
      isListLoading: isListLoading ?? this.isListLoading,
      videoLoading: videoLoading ?? this.videoLoading,
      isFavourite: isFavourite ?? this.isFavourite,
      chewieController: chewieController ?? this.chewieController,
      videoPlayerController:
          videoPlayerController ?? this.videoPlayerController,
      totalCourse: totalCourse ?? this.totalCourse,
      isFiltered: isFiltered ?? this.isFiltered,
      courseDetails: courseDetails ?? this.courseDetails,
      mostPopular: mostPopular ?? this.mostPopular,
      courseList: courseList ?? this.courseList,
      selectedShortRating: selectedShortRating ?? this.selectedShortRating,
      selectedShortBasic: selectedShortBasic ?? this.selectedShortBasic,
      selectedShortCourseFee:
          selectedShortCourseFee ?? this.selectedShortCourseFee,
      selectFilterRating: selectFilterRating ?? this.selectFilterRating,
      selectedFilterRangeValue:
          selectedFilterRangeValue ?? this.selectedFilterRangeValue,
      currentPlay: currentPlay ?? this.currentPlay,
    );
  }

  Course _update(Course state) {
    return Course(
      isLoading: state.isLoading,
      isListLoading: state.isListLoading,
      isFavourite: state.isFavourite,
      videoLoading: state.videoLoading,
      totalCourse: state.totalCourse,
      chewieController: state.chewieController,
      videoPlayerController:
          state.videoPlayerController ?? videoPlayerController,
      isFiltered: state.isFiltered,
      courseDetails: state.courseDetails,
      mostPopular: state.mostPopular,
      courseList: state.courseList,
      selectedShortRating: state.selectedShortRating,
      selectedShortBasic: state.selectedShortBasic,
      selectedShortCourseFee: state.selectedShortCourseFee,
      selectFilterRating: state.selectFilterRating,
      selectedFilterRangeValue: state.selectedFilterRangeValue,
      currentPlay: state.currentPlay ?? currentPlay,
    );
  }
}

final courseController =
    StateNotifierProvider.autoDispose<CourseController, Course>((ref) {
  ApGlobalFunctions.prepareShortAndFilterData(
      ApGlobalFunctions.navigatorKey.currentState!.context);
  return CourseController(
      Course(
        courseList: [],
        mostPopular: [],
        isFiltered: false,
        videoLoading: false,
        selectedShortCourseFee: shortFilterList[0],
        selectedShortRating: shortFilterList[0],
        selectedShortBasic: shortBasicFilterList[3],
        selectFilterRating: ratingFilterList[0],
        selectedFilterRangeValue: const RangeValues(0, 50),
        currentPlay: CurrentPlay(fileSystem: FileSystem.image.name),
      ),
      ref);
});

class FreeCourseEnrollController extends StateNotifier<bool> {
  final Ref ref;
  FreeCourseEnrollController(this.ref) : super(false);

  Future<CommonResponse> freeCourseEnroll({required int courseId}) async {
    try {
      state = true;
      final response =
          await ref.read(courseServiceProvider).freeCourseEnroll(id: courseId);

      if (response.statusCode == 200) {
        state = false;
        return CommonResponse(
            isSuccess: true, message: response.data['message']);
      }

      state = false;
      return CommonResponse(
          isSuccess: false, message: response.data['message']);
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: false, message: error.toString());
    }
  }
}

final freeCourseEnrollController =
    StateNotifierProvider<FreeCourseEnrollController, bool>((ref) {
  return FreeCourseEnrollController(ref);
});
