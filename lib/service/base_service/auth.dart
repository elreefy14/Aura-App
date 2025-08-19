import 'package:ready_lms/model/authentication/signup_credential.dart';
import 'package:dio/dio.dart';

abstract class Auth {
  Future<Response> login({required String contact, required String password});
  Future<Response> getGuestId();
  Future<Response> activeAccountRequest();
  Future<Response> registration({
    required SignUpCredential signUpCredential,
  });
  Future<Response> activeAccount({required String otp});

  Future<Response> resetPassRequest({required String id});

  Future<Response> validateOtpForResetPass(
      {required String id, required String otp});
  Future<Response> resetPassword({required String pass});
  Future<Response> updatePassword(
      {required String oldPass, required String newPass});
  // Future<Response> settings();
}
