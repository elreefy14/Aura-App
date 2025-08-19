import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ready_lms/config/app_components.dart';
import 'package:ready_lms/config/app_input_decor.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/entensions.dart';

final List<AppLanguage> _languages = [
  AppLanguage(
      name: '\ud83c\uddfa\ud83c\uddf8  English',
      value: 'en',
      popUpName: 'English',
      flag: 'assets/svg/flag_us.svg'),
  AppLanguage(
      name: '🇧🇩 বাংলা',
      value: 'bn',
      popUpName: "বাংলা",
      flag: 'assets/svg/flag_bn.svg'),
  AppLanguage(
      name: '🇸🇦 Arabic',
      value: 'ar',
      popUpName: "Arabic",
      flag: 'assets/svg/flag_sa.svg'),
];

class LanguageCard extends StatelessWidget {
  const LanguageCard({super.key});

  @override
  Widget build(BuildContext context) {
    String language = Hive.box(AppHSC.appSettingsBox).get(
      AppHSC.appLocal,
      defaultValue: 'en',
    );
    AppLanguage selectedLanguage =
        _languages.firstWhere((_) => _.value == language);
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
            S.of(context).language,
            style: AppTextStyle(context).bodyText.copyWith(),
          ),
          const Spacer(),
          // Row(children: [
          //   Icon(Icons.filter_b_and_w_rounded,weight: 24.h,),
          //   4.ph,
          //   Text(
          //       S.of(context).language,
          //       style: AppTextStyle(context).bodyText.copyWith(),
          //     ),

          // ],)

          PopupMenuButton(
            child: Row(
              children: [
                SvgPicture.asset(
                  selectedLanguage.flag,
                  width: 20.h,
                  height: 16.h,
                ),
                2.pw,
                Text(selectedLanguage.popUpName!,
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(fontWeight: FontWeight.w600)),
                2.pw, // Add spacing between icon and text
                Icon(
                  Icons.keyboard_arrow_down_outlined,
                  size: 20.h,
                )
              ],
            ),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  value: 'en',
                  child: Text('\ud83c\uddfa\ud83c\uddf8 ENG'),
                ),
                const PopupMenuItem(
                  value: 'bn',
                  child: Text('🇧🇩 বাংলা'),
                ),
                const PopupMenuItem(
                  value: 'ar',
                  child: Text('🇸🇦 Arabic'),
                ),
              ];
            },
            onSelected: (value) {
              switch (value) {
                case 'en':
                  Hive.box(AppHSC.appSettingsBox).put(AppHSC.appLocal, value);
                  break;
                case 'bn':
                  Hive.box(AppHSC.appSettingsBox).put(AppHSC.appLocal, value);
                  break;
                case 'ar':
                  Hive.box(AppHSC.appSettingsBox).put(AppHSC.appLocal, value);
                  break;
              }
            },
          )
        ],
      ),
    );
  }
}

class LocaLizationSelector extends StatelessWidget {
  const LocaLizationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyle(context);
    return FormBuilderDropdown<String>(
      decoration: AppInputDecor.appInputDecor(context).copyWith(
        fillColor: colors(context).accentColor,
      ),
      iconSize: 25.sp,
      initialValue:
          Hive.box(AppHSC.appSettingsBox).get(AppHSC.appLocal) as String?,
      iconEnabledColor: colors(context).primaryColor,
      dropdownColor: colors(context).accentColor,
      name: 'language',
      items: _languages
          .map(
            (e) => DropdownMenuItem(
              value: e.value,
              child: Text(
                e.name,
                style: textStyle.subTitle.copyWith(
                    color: colors(context).primaryColor, fontSize: 16),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null && value != '') {
          Hive.box(AppHSC.appSettingsBox).put(AppHSC.appLocal, value);
        }
      },
    );
  }
}

class AppLanguage {
  String name;
  String value;
  String? popUpName;
  String flag;
  AppLanguage({
    required this.name,
    required this.value,
    this.popUpName,
    required this.flag,
  });
}
