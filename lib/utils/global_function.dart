import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/controllers/dashboard_nav.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/authentication/user.dart';
import 'package:ready_lms/model/short_filter.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class ApGlobalFunctions {
  ApGlobalFunctions._();

  static void changeStatusBarColor({
    required Color color,
    Brightness? iconBrightness,
    Brightness? brightness,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: color, //or set color with: Color(0xFF0000FF)
        statusBarIconBrightness:
            iconBrightness ?? Brightness.dark, // For Android (dark icons)
        statusBarBrightness: brightness ?? Brightness.light,
      ),
    );
  }

  static String convertMinutesToHours(int minutes, BuildContext context) {
    int hours = (minutes / 60).floor();
    int remainingMinutes = minutes % 60;
    if (hours == 0 && remainingMinutes == 0) return '0 ${S.of(context).min}';
    if (hours == 0) return '$remainingMinutes ${S.of(context).min}';
    if (remainingMinutes == 0) return '$hours ${S.of(context).hour}';

    return '$hours ${S.of(context).hour} $remainingMinutes ${S.of(context).min}';
  }

  static cAppBar({bool showLogo = false, required Widget header}) {
    return AppBar(
       title: header,
      actions: [
        ValueListenableBuilder(
            valueListenable: Hive.box(AppHSC.userBox).listenable(),
            builder: (context, userBox, _) {
              String? image;
              final bool isGuest =
                  userBox.get(AppHSC.isGuest, defaultValue: true) as bool;
              if (!isGuest) {
                final Map<dynamic, dynamic> userData =
                    userBox.get(AppHSC.userInfo) ?? {};
                Map<String, dynamic> userInfoStringKeys =
                    userData.cast<String, dynamic>();
                final userInfo = User.fromMap(userInfoStringKeys);
                image = userInfo.profilePicture;
              }

              //old code from hive
              // final Map<dynamic, dynamic> userData = userBox.values.first;

              return Consumer(builder: (context, ref, _) {
                return GestureDetector(
                  onTap: () {
                    ref.read(homeTabControllerProvider.notifier).state = 3;
                  },
                  child: Container(
                    width: 32.h,
                    height: 32.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.h),
                      child: image == null
                          ? Center(
                              child: Image.asset(
                                'assets/images/im_demo_user_1.png',
                                fit: BoxFit.cover,
                              ),
                            )
                          : FadeInImage.assetNetwork(
                              placeholder: 'assets/images/spinner.gif',
                              image: image,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                );
              });
            }),
        16.pw
      ],
    );
  }

  static prepareShortAndFilterData(BuildContext context) {
    shortFilterList = [
      ShortFilter(S.of(context).cDefault, ''),
      ShortFilter(S.of(context).hToL, 'desc'),
      ShortFilter(S.of(context).lToH, 'asc'),
    ];
    shortBasicFilterList = [
      ShortFilter(S.of(context).newFirst, 'published_at'),
      ShortFilter(S.of(context).popularFirst, 'view_count'),
      ShortFilter(S.of(context).longDurationFirst, 'total_duration'),
      ShortFilter(S.of(context).cDefault, ''),
    ];
    ratingFilterList = [
      ShortFilter('5.0', '5'),
      ShortFilter('4.0', '4'),
      ShortFilter('3.0', '3'),
      ShortFilter('2.0', '2'),
      ShortFilter('1.0', '1'),
    ];
  }

  static void showCustomSnackbar({
    required String message,
    required bool isSuccess,
    bool isTop = false,
  }) {
    final BuildContext? ctx =
        navigatorKey.currentState?.context ?? scaffoldMessengerKey.currentContext;
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          16.r,
        ),
      ),
      dismissDirection:
          isTop ? DismissDirection.startToEnd : DismissDirection.down,
      backgroundColor:
          isSuccess ? AppStaticColor.greenColor : AppStaticColor.redColor,
      content: Text(message),
      margin: isTop && ctx != null
          ? EdgeInsets.only(
              bottom: MediaQuery.of(ctx).size.height - 160,
              right: 20,
              left: 20,
            )
          : null,
    );
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }

  static noItemFound(
      {String? text, double? size, required BuildContext context}) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double adjustedHeight =
        (screenHeight - 200).clamp(0.0, double.infinity);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: size ?? adjustedHeight,
        //height: size ?? MediaQuery.of(context).size.height - 200,
        child: Center(
          child: Text(text ?? S.of(context).noDataFound,
              style: AppTextStyle(context).bodyTextSmall),
        ),
      ),
    );
  }

  static getPickImageAlert(
      {required BuildContext context,
      required VoidCallback pressCamera,
      required VoidCallback pressGallery}) {
    showModalBottomSheet<void>(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      constraints: const BoxConstraints(maxWidth: 640),
      builder: (context) {
        return Container(
          color: Theme.of(context).colorScheme.surface,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: pressGallery,
                child: Container(
                  margin: EdgeInsets.only(bottom: 1.w),
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: ListTile(
                    leading: const Icon(
                      Icons.attach_file,
                    ),
                    title: Text(S.of(context).uploadFromGallery),
                  ),
                ),
              ),
              InkWell(
                onTap: pressCamera,
                child: Container(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: ListTile(
                    leading: const Icon(
                      Icons.add_a_photo,
                    ),
                    title: Text(S.of(context).takePhoto),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String toDateFormateMinHouDayWeekDateAgo(
      String dateTime, BuildContext context) {
    final now = DateTime.now();
    final difference = now.difference(DateTime.parse(dateTime));

    if (difference.inSeconds < 60) {
      return S.of(context).justNow;
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${S.of(context).minutes} ${S.of(context).ago}';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${S.of(context).hours} ${S.of(context).ago}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${S.of(context).days} ${S.of(context).ago}';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? S.of(context).week : S.of(context).weeks} ${S.of(context).ago}';
    } else {
      return DateFormat('MMM dd, yyyy').format(DateTime.parse(dateTime));
    }
  }

  static String toHourMinute(
      {required int time, required BuildContext context}) {
    Duration duration = Duration(seconds: time);

    String hoursString = duration.inHours > 0
        ? '${duration.inHours} ${S.of(context).hours} '
        : '';
    String minutesString = duration.inMinutes.remainder(60) > 0
        ? '${duration.inMinutes.remainder(60)} ${S.of(context).minute} '
        : '';

    return '$hoursString$minutesString';
  }

  static showBottomSheet({
    required BuildContext context,
    required Widget widget,
    bool isDismissible = false,
    bool enableDrag = true,
  }) {
    showModalBottomSheet<void>(
      isScrollControlled: true,
      showDragHandle: false,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      elevation: 0,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: context.color.surface,
      // TODO: Remove when this is in the framework https://github.com/flutter/flutter/issues/118619
      constraints: const BoxConstraints(maxWidth: 640),
      builder: (context) {
        return widget;
      },
    );
  }

  static String getFileIcon(String type) {
    if (FileSystem.audio.name == type) {
      return 'assets/svg/ic_audio_file.svg';
    }
    if (FileSystem.video.name == type) {
      return 'assets/svg/ic_video_file.svg';
    }
    if (FileSystem.document.name == type) {
      return 'assets/svg/ic_note_file.svg';
    }
    return 'assets/svg/ic_image_file.svg';
  }

  static Future<String?> getPath() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
    Directory? appDocDir;

    if (Platform.isAndroid) {
      appDocDir = Directory('/storage/emulated/0/Download');
      if (!await appDocDir.exists()) {
        appDocDir = await getExternalStorageDirectory();
      }
    } else if (Platform.isIOS) {
      appDocDir = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
    return appDocDir?.path;
  }

  static showSnacbarMethod({
    required BuildContext context,
    required String message,
    required bool isSuccess,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        content: Text(message),
      ),
    );
  }

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> getSnackbarKey() =>
    scaffoldMessengerKey;

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
