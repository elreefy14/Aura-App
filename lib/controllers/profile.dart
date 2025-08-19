import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/authentication/user.dart';
import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/model/updateUser.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/service/profile.dart';

class ProfileController extends StateNotifier<bool> {
  final Ref ref;
  ProfileController(this.ref) : super(false);

  Future<CommonResponse> updateProfile({required UpdateUser user}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response =
          await ref.read(profileServiceProvider).updateProfile(user: user);
      state = false;
      if (response.statusCode == 200) {
        isSuccess = true;
        final userInfo = User.fromMap(response.data['data']['user']);
        ref
            .read(hiveStorageProvider)
            .saveUserInfo(userInfo: userInfo, isGuest: false);
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

final profileController =
    StateNotifierProvider.autoDispose<ProfileController, bool>(
        (ref) => ProfileController(ref));
