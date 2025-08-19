import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/model/course_list.dart';
import 'package:ready_lms/service/certificate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CertificateController extends StateNotifier<Certificate> {
  final Ref ref;
  CertificateController(super.state, this.ref);

  Future<CommonResponse> getCertificateList(
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
      final response = await ref
          .read(certificateServiceProvider)
          .getCertificateList(currentPage: currentPage, parPage: parPage);
      if (response.statusCode == 200) {
        isSuccess = true;
        final List<dynamic> responseList =
            response.data['data']['certificate_courses'];
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
}

class Certificate {
  List<CourseListModel> courseList;
  bool isLoading;
  Certificate({required this.courseList, this.isLoading = false});
  Certificate copyWith({courseList, isLoading}) {
    return Certificate(
        isLoading: isLoading ?? this.isLoading,
        courseList: courseList ?? this.courseList);
  }

  Certificate _update(Certificate state) {
    return Certificate(
      isLoading: state.isLoading,
      courseList: state.courseList,
    );
  }
}

final certificateController =
    StateNotifierProvider<CertificateController, Certificate>(
        (ref) => CertificateController(Certificate(courseList: []), ref));
