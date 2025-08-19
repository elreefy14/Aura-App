import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_constants.dart';

AppColors colors(context) => Theme.of(context).extension<AppColors>()!;
ThemeData getAppTheme(
    {required BuildContext context, required bool isDarkTheme}) {
  return ThemeData(
    extensions: <ThemeExtension<AppColors>>[
      AppColors(
          primaryColor: isDarkTheme
              ? AppStaticColor.primaryDarkColor
              : AppStaticColor.primaryColor,
          accentColor: AppStaticColor.accentColor,
          buttonColor: isDarkTheme
              ? AppStaticColor.primaryDarkColor
              : AppStaticColor.primaryColor,
          buttonTextColor: AppStaticColor.whiteColor,
          bodyTextColor: isDarkTheme
              ? AppStaticColor.whiteColor
              : AppStaticColor.grayColor,
          bodyTextSmallColor: isDarkTheme
              ? AppStaticColor.whiteColor
              : AppStaticColor.blackColor,
          titleTextColor: isDarkTheme
              ? AppStaticColor.whiteColor
              : AppStaticColor.blackColor,
          hintTextColor: isDarkTheme
              ? AppStaticColor.accentColor
              : AppStaticColor.grayColor,
          scaffoldBackgroundColor:
              isDarkTheme ? const Color(0xFF1C1C1E) : const Color(0xFFF3F4F6),
          borderColor: isDarkTheme
              ? AppStaticColor.accentColor
                  .withOpacity(AppConstants.hintColorBorderOpacity)
              : AppStaticColor.grayColor
                  .withOpacity(AppConstants.hintColorBorderOpacity)),
    ],
    fontFamily: 'Lexend',
    colorScheme: isDarkTheme
        ? ColorScheme.fromSeed(
            seedColor: AppStaticColor.primaryDarkColor,
            surface: AppStaticColor.blackColor,
            brightness: Brightness.dark)
        : ColorScheme.fromSeed(
            seedColor: AppStaticColor.primaryColor,
            surface: AppStaticColor.whiteColor,
            brightness: Brightness.light),
    useMaterial3: true,
    unselectedWidgetColor:
        isDarkTheme ? AppStaticColor.accentColor : AppStaticColor.grayColor,
    scaffoldBackgroundColor:
        isDarkTheme ? const Color(0xFF1C1C1E) : const Color(0xFFF3F4F6),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.transparent,
      backgroundColor:
          isDarkTheme ? AppStaticColor.blackColor : AppStaticColor.whiteColor,
      titleTextStyle: TextStyle(
          color: isDarkTheme
              ? AppStaticColor.whiteColor
              : AppStaticColor.blackColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          fontFamily: 'Lexend',
          overflow: TextOverflow.ellipsis),
      centerTitle: false,
      elevation: 0,
      iconTheme: IconThemeData(
        color:
            isDarkTheme ? AppStaticColor.whiteColor : AppStaticColor.blackColor,
      ),
    ),
    inputDecorationTheme: inputDecorationTheme(isDarkTheme: isDarkTheme),
  );
}

InputDecorationTheme inputDecorationTheme({
  required bool isDarkTheme,
}) {
  Color borderColor = isDarkTheme
      ? AppStaticColor.accentColor
          .withOpacity(AppConstants.hintColorBorderOpacity)
      : AppStaticColor.grayColor
          .withOpacity(AppConstants.hintColorBorderOpacity);
  return InputDecorationTheme(
    // floatingLabelBehavior: FloatingLabelBehavior.always,
    isDense: false,
    contentPadding: const EdgeInsets.all(15),
    hintStyle: const TextStyle(
        color: AppStaticColor.grayColor,
        fontSize: 16,
        fontWeight: FontWeight.w300),
    filled: false,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.h),
      borderSide: BorderSide(color: borderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.h),
      borderSide: BorderSide(color: borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.h),
      borderSide: const BorderSide(color: AppStaticColor.primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.h),
      borderSide: const BorderSide(color: AppStaticColor.redColor),
    ),
  );
}
