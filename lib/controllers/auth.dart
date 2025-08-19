import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/authentication/signup_credential.dart';
import 'package:ready_lms/model/authentication/user.dart';
import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/service/auth.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/utils/api_client.dart';

class AuthController extends StateNotifier<bool> {
  final Ref ref;
  AuthController(this.ref) : super(false);

  Future<CommonResponse> login(
      {required String contact, required String password}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref
          .read(authServiceProvider)
          .login(contact: contact, password: password);
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
        final userInfo = User.fromMap(response.data['data']['user']);
        final authToken = response.data['data']['token'];
        ref
            .read(hiveStorageProvider)
            .saveUserInfo(userInfo: userInfo, isGuest: false);
        ref.read(hiveStorageProvider).saveUserAuthToken(authToken: authToken);
        ref.read(apiClientProvider).updateToken(token: authToken);
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> signUp(SignUpCredential signUpCredential) async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref
          .read(authServiceProvider)
          .registration(signUpCredential: signUpCredential);
      state = false;
      if (response.statusCode == 201) {
        isSuccess = true;
        final userInfo = User.fromMap(response.data['data']['user']);
        final authToken = response.data['data']['token'];
        ref
            .read(hiveStorageProvider)
            .saveUserInfo(userInfo: userInfo, isGuest: false);
        ref.read(hiveStorageProvider).saveUserAuthToken(authToken: authToken);
        ref.read(apiClientProvider).updateToken(token: authToken);
        ref
            .read(apiClientProvider)
            .setActiveCode(code: response.data['data']['activation_code']);
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> getGuestId() async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref.read(authServiceProvider).getGuestId();
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  // Future<AuthResponseModel> sendOTP({required String contact}) async {
  //   state = true;
  //   try {
  //     final repoonseModel =
  //         await ref.read(authService).sendOTP(contact: contact);
  //     state = false;
  //     return repoonseModel;
  //   } catch (error) {
  //     return AuthResponseModel(isSuccess: false, message: error.toString());
  //   } finally {
  //     state = false;
  //   }
  // }

  Future<CommonResponse> activeAccountByOtp({required String otp}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response =
          await ref.read(authServiceProvider).activeAccount(otp: otp);
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
        final authToken = response.data['data']['token'];
        ref.read(hiveStorageProvider).saveUserAuthToken(authToken: authToken);
        ref.read(apiClientProvider).updateToken(token: authToken);
        ref.read(hiveStorageProvider).makeUserActive();
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> resetPassRequest({required String id}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response =
          await ref.read(authServiceProvider).resetPassRequest(id: id);
      state = false;
      if (response.statusCode == 201) {
        isSuccess = true;
        ref
            .read(apiClientProvider)
            .setActiveCode(code: response.data['data']['otp']);
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> validateOtpForResetPass(
      {required String id, required String otp}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref
          .read(authServiceProvider)
          .validateOtpForResetPass(id: id, otp: otp);
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
        final authToken = response.data['data']['token'];
        ref.read(hiveStorageProvider).saveUserAuthToken(authToken: authToken);
        ref.read(apiClientProvider).updateToken(token: authToken);
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> resetPassword({required String pass}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response =
          await ref.read(authServiceProvider).resetPassword(pass: pass);
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> updatePassword(
      {required String oldPass, required String newPass}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response = await ref
          .read(authServiceProvider)
          .updatePassword(oldPass: oldPass, newPass: newPass);
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }

  Future<CommonResponse> activeAccountRequest() async {
    state = true;
    bool isSuccess = false;
    try {
      final response =
          await ref.read(authServiceProvider).activeAccountRequest();
      state = false;
      if (response.statusCode == 201) {
        isSuccess = true;
        ref
            .read(apiClientProvider)
            .setActiveCode(code: response.data['data']['activation_code']);
      }
      return CommonResponse(
        isSuccess: isSuccess,
        message: response.data['message'],
      );
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }
}

final authController = StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(ref);
});
