import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/authentication/user.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileWidget extends ConsumerWidget {
  const ProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(AppHSC.userBox).listenable(),
        builder: (context, userBox, _) {
          User? userInfo;
          String? imageUrl;
          final bool isGuest =
              userBox.get(AppHSC.isGuest, defaultValue: true) as bool;
          if (!isGuest) {
            final Map<dynamic, dynamic> userData =
                userBox.get(AppHSC.userInfo) ?? {};
            Map<String, dynamic> userInfoStringKeys =
                userData.cast<String, dynamic>();
            userInfo = User.fromMap(userInfoStringKeys);
            imageUrl = userInfo.profilePicture;
          }
          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/profile_background.png'),
                    fit: BoxFit.cover)),
            child: SafeArea(
                child: Column(
              children: [
                20.ph,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.h),
                  child: Row(
                    children: [
                      Container(
                        width: 96.h,
                        height: 96.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: colors(context).primaryColor!,
                                width: 3.h)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.h),
                          child: imageUrl == null
                              ? Center(
                                  child: Image.asset(
                                    'assets/images/im_demo_user_1.png',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/spinner.gif',
                                  image: imageUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      16.pw,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).hello,
                              style:
                                  AppTextStyle(context).bodyTextSmall.copyWith(
                                        color: context.color.surface,
                                      ),
                            ),
                            if (!isGuest)
                              Text(
                                userInfo!.name!,
                                style: AppTextStyle(context).bodyText.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                    ),
                              ),
                            if (isGuest)
                              Row(
                                children: [
                                  Text(
                                    S.of(context).learner,
                                    style:
                                        AppTextStyle(context).bodyText.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                      onPressed: () {
                                        context.nav
                                            .pushNamed(Routes.authHomeScreen);
                                      },
                                      child: Text(
                                        S.of(context).pleaseLogin,
                                        style: AppTextStyle(context)
                                            .bodyTextSmall
                                            .copyWith(
                                                color: colors(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w700),
                                      ))
                                ],
                              ),
                            if (!isGuest) 4.ph,
                            if (!isGuest)
                              Row(
                                children: [
                                  Text(
                                    userInfo!.phone!,
                                    style:
                                        AppTextStyle(context).bodyText.copyWith(
                                              fontWeight: FontWeight.w700,
                                              color: context.color.surface,
                                            ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => context.nav
                                        .pushNamed(Routes.profileScreen),
                                    child: SvgPicture.asset(
                                      'assets/svg/ic_edit.svg',
                                      color: context.color.surface,
                                      width: 24.h,
                                      height: 24.h,
                                    ),
                                  )
                                ],
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                28.ph
              ],
            )),
          );
        });
  }
}
