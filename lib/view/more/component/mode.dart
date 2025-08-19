import 'package:ready_lms/config/app_color.dart';
import 'package:ready_lms/config/app_components.dart';

import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/hive_contants.dart';

import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ModeCard extends StatelessWidget {
  const ModeCard({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = Hive.box(AppHSC.appSettingsBox).get(
      AppHSC.isDarkTheme,
      defaultValue: false,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
          borderRadius: AppComponents.defaultBorderRadiusLarge,
          color: Theme.of(context).hintColor.withOpacity(.07)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isDarkTheme ? S.of(context).dark : S.of(context).light,
            style: AppTextStyle(context).bodyText.copyWith(),
          ),
          const Spacer(),
          SizedBox(
            height: 24.h,
            child: Switch(
              value: isDarkTheme,
              onChanged: (bool isOn) {
                Hive.box(AppHSC.appSettingsBox).put(AppHSC.isDarkTheme, isOn);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: AppStaticColor.primaryColor,
              inactiveTrackColor: context.color.surface,
              inactiveThumbColor: context.color.primaryContainer,
              trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            ),
          )
        ],
      ),
    );
  }
}
