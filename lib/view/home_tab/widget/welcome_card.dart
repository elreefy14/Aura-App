import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/hive_contants.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/authentication/user.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/view/home_tab/widget/home_custom_crv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WelcomeCard extends StatelessWidget {
  const WelcomeCard({
    super.key,
    required this.totalCourse,
  });
  final int totalCourse;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.h),
      child: ClipPath(
          clipper: TriangleClipper(),
          child: Container(
            width: double.infinity,
            color: colors(context).primaryColor!.withOpacity(.8),
            child: Row(
              children: [
                5.pw,
                Image.asset(
                  'assets/images/home_welcome_avt.png',
                  width: 136.h,
                  height: 208.h,
                ),
                16.pw,
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.only(
                    right: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      16.ph,
                      ValueListenableBuilder(
                          valueListenable:
                              Hive.box(AppHSC.userBox).listenable(),
                          builder: (context, userBox, _) {
                            String name = S.of(context).learner;
                            final bool isGuest = userBox.get(AppHSC.isGuest,
                                defaultValue: true) as bool;
                            if (!isGuest) {
                              final Map<dynamic, dynamic> userData =
                                  userBox.get(AppHSC.userInfo) ?? {};
                              Map<String, dynamic> userInfoStringKeys =
                                  userData.cast<String, dynamic>();
                              final userInfo = User.fromMap(userInfoStringKeys);
                              name = userInfo.name ?? '';
                            }
                            return Text(
                              "${S.of(context).hi} $name 👋",
                              style: AppTextStyle(context).bodyText.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                            );
                          }),
                      5.ph,
                      Text(
                        S.of(context).welcomeText,
                        style: AppTextStyle(context).bodyText.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                      ),
                      24.ph,
                      Row(
                        children: [
                          Text(
                            ' ${totalCourse - 1}+ ${S.of(context).course}',
                            style: AppTextStyle(context).bodyText.copyWith(
                                  fontSize: 12.sp,
                                  color: const Color(0xFFEEDDFE),
                                ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.nav
                                .pushNamed(Routes.courseSearchScreen),
                            child: Container(
                              width: 36.h,
                              height: 36.h,
                              decoration: BoxDecoration(
                                color: context.color.surface,
                                shape: BoxShape.circle,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(13.h),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/svg/ic_search.svg',
                                    width: 16.h,
                                    height: 16.h,
                                    color: colors(context).titleTextColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      44.ph
                    ],
                  ),
                ))
              ],
            ),
          )),
    );
  }
}
