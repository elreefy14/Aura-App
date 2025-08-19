import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/components/busy_loader.dart';

class AppCustomDivider extends StatelessWidget {
  const AppCustomDivider({
    super.key,
    this.height = 1.0,
    this.width = 1.0,
    this.color = AppStaticColor.grayColor,
  });
  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(100.h)),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.showBG = false});
  final bool showBG;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BusyLoader(showbackground: showBG),
    );
  }
}
