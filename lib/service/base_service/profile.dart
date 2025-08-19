import 'package:ready_lms/model/updateUser.dart';
import 'package:dio/dio.dart';

abstract class Profile {
  Future<Response> updateProfile({required UpdateUser user});
}
