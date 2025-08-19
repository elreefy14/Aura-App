import 'package:ready_lms/model/contact_support.dart';
import 'package:dio/dio.dart';

abstract class Other {
  Future<Response> makeReview(
      {required int id, required Map<String, dynamic> data});
  Future<Response> contactSupport({required ContactSupport contactSupport});
  Future<Response> deleteAccount();
  Future<Response> masterCall();
}
