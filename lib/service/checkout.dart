import 'package:dio/src/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/service/base_service/checkout.dart';
import 'package:ready_lms/utils/api_client.dart';

class CheckOutService extends CheckOut {
  final Ref ref;
  CheckOutService(this.ref);

  @override
  Future<Response> courseDetailByID({required int id}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.courseDetail + id.toString());
    return response;
  }

  @override
  Future<Response> enrollCourseById(
      {required int id,
      int? couponId,
      required Map<String, dynamic> query}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.purchase + id.toString(), query: query);
    return response;
  }

  @override
  Future<Response> couponValidate({required String code}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.couponValidate, query: {'coupon_code': code});
    return response;
  }
}

final checkoutServiceProvider = Provider((ref) => CheckOutService(ref));
