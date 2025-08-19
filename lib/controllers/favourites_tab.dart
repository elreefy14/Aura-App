import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/model/course_list.dart' as instr;
import 'package:ready_lms/model/course_list.dart';
import 'package:ready_lms/service/auth.dart';
import 'package:ready_lms/service/favourites_tab.dart';
import 'package:ready_lms/service/hive_service.dart';

class FavouriteTabController extends StateNotifier<Favourite> {
  final Ref ref;
  FavouriteTabController(super.state, this.ref);

  Future<CommonResponse> getFavouriteList(
      {bool isRefresh = false,
      required int currentPage,
      int parPage = 10}) async {
    if (isRefresh) {
      state.isLoading = true;
      state.courseList.clear();
      state = state._update(state);
    }
    bool isSuccess = false;
    bool hasData = false;
    try {
      String? guestId;
      if (ref.read(hiveStorageProvider).isGuest()) {
        guestId = ref.read(hiveStorageProvider).guestId();
        if (guestId == null) {
          final response = await ref.read(authServiceProvider).getGuestId();
          guestId = response.data['data']['guest_id'];
          ref.read(hiveStorageProvider).setGuestId(guestId!);
        }
      }
      final response = await ref
          .read(favouriteTabServiceProvider)
          .getFavouriteList(
              guestId: guestId, currentPage: currentPage, parPage: parPage);
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
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<CommonResponse> favouriteUpdate({required int id}) async {
    bool isSuccess = false;
    try {
      String? guestId;
      if (ref.read(hiveStorageProvider).isGuest()) {
        guestId = ref.read(hiveStorageProvider).guestId();
        if (guestId == null) {
          final response = await ref.read(authServiceProvider).getGuestId();
          guestId = response.data['data']['guest_id'];
        }
      }
      final response = await ref
          .read(favouriteTabServiceProvider)
          .FavouriteUpdate(courseId: id, guestId: guestId);

      if (response.statusCode == 200) {
        isSuccess = true;
      }
      return CommonResponse(
          isSuccess: isSuccess,
          message: response.data['message'],
          response: response.data['data']['is_added']);
    } catch (error) {
      debugPrint(error.toString());
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {}
  }

  addFavouriteOnList(CourseDetailModel model) {
    state.courseList.insert(
        0,
        CourseListModel(
            id: model.course.id,
            category: model.course.category,
            title: model.course.title,
            thumbnail: model.course.thumbnail,
            viewCount: model.course.viewCount,
            regularPrice: model.course.regularPrice,
            price: model.course.price,
            instructor: instr.Instructor(
                id: model.course.instructor.id,
                name: model.course.instructor.name,
                profilePicture: model.course.instructor.profilePicture,
                title: model.course.instructor.title,
                isFeatured: model.course.instructor.isFeatured),
            publishedAt: model.course.publishedAt,
            totalDuration: model.course.totalDuration,
            videoCount: model.course.videoCount,
            noteCount: model.course.noteCount,
            audioCount: model.course.audioCount,
            chapterCount: model.course.chapterCount,
            studentCount: model.course.studentCount,
            reviewCount: model.course.reviewCount,
            averageRating: model.course.averageRating,
            isFavourite: model.course.isFavourite,
            isEnrolled: model.course.isEnrolled,
            isReviewed: model.course.isReviewed,
            canReview: model.course.canReview,
            isFree: model.course.isFree));
    state = state._update(state);
  }

  removeFavouriteOnList(int id) {
    if (state.courseList.map((e) => e.id).contains(id)) {
      state.courseList.removeWhere((element) => element.id == id);
    }
    state = state._update(state);
  }
}

class Favourite {
  List<CourseListModel> courseList;
  bool isLoading;
  Favourite({required this.courseList, this.isLoading = false});
  Favourite copyWith({courseList, isLoading}) {
    return Favourite(
        isLoading: isLoading ?? this.isLoading,
        courseList: courseList ?? this.courseList);
  }

  Favourite _update(Favourite state) {
    return Favourite(
      isLoading: state.isLoading,
      courseList: state.courseList,
    );
  }
}

final favouriteTabController =
    StateNotifierProvider<FavouriteTabController, Favourite>(
        (ref) => FavouriteTabController(Favourite(courseList: []), ref));
