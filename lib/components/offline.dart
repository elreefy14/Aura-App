import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/gen/assets.gen.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.noInternetConnection.image(),
              const SizedBox(
                height: 40,
              ),
              Text(
                S.of(context).whoops,
                style: AppTextStyle(context).title,
              ),
              SizedBox(height: 20.h),
              Text(
                S.of(context).noInternetDes,
                style: AppTextStyle(context)
                    .bodyText
                    .copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30.h),
              SizedBox(
                height: 50.h,
                child: AppButton(
                  title: S.of(context).checkInternetConnection,
                  titleColor: context.color.surface,
                  onTap: () async {
                    AppSettings.openAppSettings(type: AppSettingsType.wifi);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final String noInternetDes =
      "No Internet connection was found. Check you connection or try again.";
}
