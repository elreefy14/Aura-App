import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/model/course_list.dart';
import 'package:ready_lms/service/courses/course.dart';

class MyCourseTabController extends StateNotifier<Course> {
  final Ref ref;
  MyCourseTabController(super.state, this.ref);

  Future<CommonResponse> getMyEnrollCourse(
      {bool isRefresh = false,
      required int currentPage,
      int parPage = 10}) async {
    if (isRefresh) {
      state.isLoading = true;
      state.enrollCourseList.clear();
      state = state._update(state);
    }

    bool isSuccess = false;
    bool hasData = false;
    try {
      final response = await ref
          .read(courseServiceProvider)
          .enrolledCourses(currentPage: currentPage, parPage: parPage);

      if (response.statusCode == 200) {
        isSuccess = true;
        List<dynamic> responseList = response.data['data']['courses'];
        List<CourseListModel> list =
            responseList.map((data) => CourseListModel.fromJson(data)).toList();

        if (list.isNotEmpty) {
          state.enrollCourseList.addAll(list);
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
      if (mounted) state = state.copyWith(isLoading: false);
    }
  }

  updateListForReview({required int courseId, required SubmittedReview data}) {
    if (state.enrollCourseList.map((e) => e.id).contains(courseId)) {
      final updatedList = [...state.enrollCourseList];
      int index = updatedList.indexWhere((element) => element.id == courseId);
      updatedList[index].canReview = false;
      updatedList[index].submittedReview = data;
      state = state.copyWith(enrollCourseList: updatedList);
    }
  }

  // addNewEnrolledCoursedOnList(CourseDetailModel model) {
  //   state.enrollCourseList.insert(
  //       0,
  //       CourseListModel(
  //           id: model.course.id,
  //           category: model.course.category,
  //           title: model.course.title,
  //           thumbnail: model.course.thumbnail,
  //           viewCount: model.course.viewCount,
  //           regularPrice: model.course.regularPrice,
  //           price: model.course.price,
  //           instructor: instr.Instructor(
  //               id: model.course.instructor.id,
  //               name: model.course.instructor.name,
  //               profilePicture: model.course.instructor.profilePicture,
  //               title: model.course.instructor.title,
  //               isFeatured: model.course.instructor.isFeatured),
  //           publishedAt: model.course.publishedAt,
  //           totalDuration: model.course.totalDuration,
  //           videoCount: model.course.videoCount,
  //           noteCount: model.course.noteCount,
  //           audioCount: model.course.audioCount,
  //           chapterCount: model.course.chapterCount,
  //           studentCount: model.course.studentCount,
  //           reviewCount: model.course.reviewCount,
  //           averageRating: model.course.averageRating,
  //           isFavourite: model.course.isFavourite,
  //           isEnrolled: true,
  //           isReviewed: model.course.isReviewed,
  //           canReview: model.course.canReview));
  //   state = state._update(state);
  // }
}

class Course {
  bool isLoading;
  List<CourseListModel> enrollCourseList;
  Course({
    this.isLoading = false,
    required this.enrollCourseList,
  });

  Course copyWith({
    isLoading,
    enrollCourseList,
  }) {
    return Course(
      isLoading: isLoading ?? this.isLoading,
      enrollCourseList: enrollCourseList ?? this.enrollCourseList,
    );
  }

  Course _update(Course state) {
    return Course(
      isLoading: state.isLoading,
      enrollCourseList: state.enrollCourseList,
    );
  }
}

final myCourseTabController =
    StateNotifierProvider.autoDispose<MyCourseTabController, Course>(
        (ref) => MyCourseTabController(Course(enrollCourseList: []), ref));
