import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/utils/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../base_service/my_course.dart';

class MyCourseDetailsService extends MyCourse {
  final Ref ref;
  MyCourseDetailsService(this.ref);

  @override
  Future<Response> courseDetailByID({required int id}) async {
    final response = await ref.read(apiClientProvider).get(
          AppConstants.courseDetail + id.toString(),
        );
    return response;
  }

  @override
  Future<Response> makeContentView({required int id}) async {
    final response = await ref.read(apiClientProvider).post(
          AppConstants.viewContent + id.toString(),
        );
    return response;
  }
}

final myCourseDetailsServiceProvider =
    Provider((ref) => MyCourseDetailsService(ref));
