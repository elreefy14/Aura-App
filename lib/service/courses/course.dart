import 'package:dio/src/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/api_client.dart';

import '../base_service/course.dart';

class CourseServiceProvider extends Course {
  final Ref ref;
  CourseServiceProvider(this.ref);

  @override
  Future<Response> courseList({
    required Map<String, dynamic>? query,
  }) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.courseList, query: query);
    return response;
  }

  @override
  Future<Response> courseDetailByID({required int id}) async {
    final response = await ref.read(apiClientProvider).get(
        AppConstants.courseDetail + id.toString(),
        query: {'guest_id': ref.read(hiveStorageProvider).guestId()});
    return response;
  }

  @override
  Future<Response> enrolledCourses(
      {required int currentPage, int? parPage}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.enrolledCourses, query: {
      AppConstants.page: '$currentPage',
      AppConstants.perPage: '$parPage'
    });
    return response;
  }

  Future<Response> freeCourseEnroll({required int id}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.freeEnroll + id.toString());
    return response;
  }
}

final courseServiceProvider = Provider((ref) => CourseServiceProvider(ref));
