import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/gen/assets.gen.dart';
import 'package:ready_lms/utils/entensions.dart';

class PermissionHandlerDialog extends StatelessWidget {
  final String buttionName;
  final void Function() onTap;
  const PermissionHandlerDialog({
    super.key,
    required this.buttionName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      content: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 100.h,
                width: 100.w,
                child: Center(
                  child: Assets.images.locationPin.image(),
                ),
              ),
              10.ph,
              Text(
                "Enable Geolocation",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              18.ph,
              Text(
                "By allowing geolocation you are able to \nexplore nearest shops!",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
              20.ph,
              GestureDetector(
                onTap: onTap,
                child: SizedBox(
                  height: 45.h,
                  child: AppOutlineButton(
                    title: buttionName,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
