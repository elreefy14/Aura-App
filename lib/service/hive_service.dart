import 'package:ready_lms/model/authentication/user.dart';
import 'package:ready_lms/model/hive_mode/hive_cart_model.dart';
import 'package:ready_lms/utils/api_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  final Ref ref;
  HiveService(this.ref);

  // save data to the local storage

  // save access token
  Future saveUserAuthToken({required String authToken}) async {
    final authBox = Hive.box(AppHSC.authBox);
    authBox.put(AppHSC.authToken, authToken);
  }

  // remove access token
  Future removeUserAuthToken() async {
    final authBox = Hive.box(AppHSC.authBox);
    authBox.delete(AppHSC.authToken);
  }

  String? guestId() {
    final userBox = Hive.box(AppHSC.userBox);
    return userBox.get(AppHSC.guestId, defaultValue: null);
  }

  bool isGuest() {
    final userBox = Hive.box(AppHSC.userBox);
    return userBox.get(AppHSC.isGuest, defaultValue: true);
  }

  setGuestId(String id) {
    final userBox = Hive.box(AppHSC.userBox);
    return userBox.put(AppHSC.guestId, id);
  }

  // save user information
  Future saveUserInfo({required User userInfo, required bool isGuest}) async {
    final userBox = Hive.box(AppHSC.userBox);
    userBox.put(AppHSC.isGuest, isGuest);
    userBox.put(AppHSC.guestId, null);
    userBox.put(AppHSC.userInfo, userInfo.toMap());
  }

  // remove user data
  Future removeUserData() async {
    final userBox = Hive.box(AppHSC.userBox);
    userBox.clear();
  }

  // save the first open status
  Future setFirstOpenValue({required bool value}) async {
    final appSettingsBox = Hive.box(AppHSC.appSettingsBox);
    appSettingsBox.put(AppHSC.firstOpen, value);
  }

  // save the first open status
  Future setDarkTheme({required bool value}) async {
    final appSettingsBox = Hive.box(AppHSC.appSettingsBox);
    appSettingsBox.put(AppHSC.isDarkTheme, value);
  }

  bool getTheme() {
    final Box box = Hive.box(AppHSC.appSettingsBox);
    final themeData = box.get(AppHSC.isDarkTheme, defaultValue: false) as bool;
    return themeData;
  }
// get data from local storge

// get user auth token
  String? getAuthToken() {
    final authBox = Hive.box(AppHSC.authBox);
    final authToken = authBox.get(AppHSC.authToken);
    if (authToken != null) {
      return authToken;
    }
    return null;
  }

// get user information
  User? getUserInfo() {
    final userBox = Hive.box(AppHSC.userBox);
    Map<dynamic, dynamic>? userInfo = userBox.get(AppHSC.userInfo);
    if (userInfo != null) {
      // Convert Map<dynamic, dynamic> to Map<String, dynamic>
      Map<String, dynamic> userInfoStringKeys =
          userInfo.cast<String, dynamic>();
      User user = User.fromMap(userInfoStringKeys);
      return user;
    }
    return null;
  }

  Future<void> makeUserActive() async {
    final userBox = Hive.box(AppHSC.userBox);
    Map<dynamic, dynamic>? userInfo = userBox.get(AppHSC.userInfo);
    if (userInfo != null) {
      // Convert Map<dynamic, dynamic> to Map<String, dynamic>
      Map<String, dynamic> userInfoStringKeys =
          userInfo.cast<String, dynamic>();
      User user = User.fromMap(userInfoStringKeys);
      user.isActive = 1;
      userBox.put(AppHSC.userInfo, user.toMap());
    }
  }

// get user first open status
  Future<bool?> getUserFirstOpenStatus() async {
    final appSettingsBox = Hive.box(AppHSC.appSettingsBox);
    final status = appSettingsBox.get(AppHSC.firstOpen);
    if (status != null) {
      return status;
    }
    return false;
  }

  Future<List<dynamic>?> loadTokenAndUser() async {
    final firstOpenStatus = await getUserFirstOpenStatus();
    final authToken = getAuthToken();
    final user = getUserInfo();

    return [firstOpenStatus, authToken, user];
  }

  Future<bool> removeAllData() async {
    try {
      await removeUserAuthToken();
      await removeCartITems();
      await removeUserData();
      ref.read(apiClientProvider).updateTokenDefault();
      return true;
    } catch (e) {
      return false;
    }
  }

  removeCartITems() {
    Box cartBox = Hive.box<HiveCartModel>(AppHSC.cartBox);
    cartBox.clear();
  }
}

final hiveStorageProvider = Provider((ref) => HiveService(ref));
