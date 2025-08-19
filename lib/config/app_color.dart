import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color? primaryColor;
  final Color? accentColor;
  final Color? buttonColor;
  final Color? buttonTextColor;
  final Color? bodyTextColor; 
  final Color? bodyTextSmallColor;
  final Color? titleTextColor;
  final Color? hintTextColor;
  final Color? borderColor;
  final Color? scaffoldBackgroundColor;

  const AppColors({
    required this.primaryColor,
    required this.accentColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.bodyTextColor,
    required this.bodyTextSmallColor,
    required this.titleTextColor,
    required this.hintTextColor,
    required this.borderColor,
    required this.scaffoldBackgroundColor,
  });

  @override
  AppColors copyWith({
    Color? primaryColor,
    Color? accentColor,
    Color? buttonColor,
    Color? buttonTextColor,
    Color? titleTextColor,
    Color? bodyTextColor,
    Color? bodyTextSmallColor,
    Color? hintTextColor,
    Color? borderColor,
    Color? scaffoldBackgroundColor,
  }) {
    return AppColors(
      primaryColor: primaryColor ?? primaryColor,
      accentColor: accentColor ?? accentColor,
      buttonColor: buttonColor ?? buttonColor,
      buttonTextColor: buttonTextColor ?? buttonTextColor,
      bodyTextColor: bodyTextColor ?? bodyTextColor,
      bodyTextSmallColor: bodyTextSmallColor ?? bodyTextSmallColor,
      titleTextColor: titleTextColor ?? titleTextColor,
      hintTextColor: hintTextColor ?? hintTextColor,
      borderColor: borderColor ?? borderColor,
      scaffoldBackgroundColor:
          scaffoldBackgroundColor ?? scaffoldBackgroundColor,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t),
      accentColor: Color.lerp(accentColor, other.accentColor, t),
      buttonColor: Color.lerp(buttonColor, other.buttonColor, t),
      buttonTextColor: Color.lerp(buttonTextColor, other.buttonTextColor, t),
      bodyTextColor: Color.lerp(bodyTextColor, other.bodyTextColor, t),
      bodyTextSmallColor:
          Color.lerp(bodyTextSmallColor, other.bodyTextSmallColor, t),
      titleTextColor: Color.lerp(titleTextColor, other.titleTextColor, t),
      hintTextColor: Color.lerp(hintTextColor, other.hintTextColor, t),
      borderColor: Color.lerp(borderColor, other.borderColor, t),
      scaffoldBackgroundColor:
          Color.lerp(scaffoldBackgroundColor, other.scaffoldBackgroundColor, t),
    );
  }
}

class AppStaticColor {
  static const Color primaryColor = Color(0xFF5864FF);
  static const Color primaryDarkColor = Color(0xFF8500FA);
  static const Color accentColor = Color(0xFFF3F4F6);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF030712);
  static const Color redColor = Color(0xffFF324B);
  static const Color grayColor = Color(0xff617986);
  static const Color orangeColor = Color(0xFFFAA809);
  static const Color yellowColor = Color(0xFFFFEE06);
  static const Color greenColor = Color(0xFF00CA45);
  static const Color blueColor = Color(0xFF306AFF);
}
