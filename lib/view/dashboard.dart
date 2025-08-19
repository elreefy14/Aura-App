import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/dashboard_nav.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/view/courses/course_tab/course_tab_screen.dart';
import 'package:ready_lms/view/home_tab/home_tab.dart';
import 'package:ready_lms/view/more/more_tab.dart';

import '../config/app_text_style.dart';
import 'favourites/favourites_tab.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool isPrepareShortFilter = false;
  bool canClose = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(homeTabControllerProvider);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) {
          return;
        }

        if (ref.read(homeTabControllerProvider) == 0) {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
        } else {
          if (mounted) ref.read(homeTabControllerProvider.notifier).state = 0;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: ref.watch(homeTabControllerProvider),
          children: const [
            HomeTab(),
            MyCourseTabScreen(),
            FavouriteTab(),
            ProfileTab(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: context.color.surface,
            boxShadow: [
              BoxShadow(
                color: context.color.onSurface.withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(1, -2),
              ),
            ],
          ),
          width: double.infinity,
          child: Row(
            children: [
              BottomTab(
                  tabIndex: 0,
                  activeIcon: 'assets/svg/home_active.svg',
                  inActiveIcon: 'assets/svg/home_inactive.svg',
                  title: S.of(context).home),
              BottomTab(
                  tabIndex: 1,
                  activeIcon: 'assets/svg/course_active2.svg',
                  inActiveIcon: 'assets/svg/course_inactive.svg',
                  title: S.of(context).myCoursesTab),
              BottomTab(
                  tabIndex: 2,
                  activeIcon: 'assets/svg/favourites_active.svg',
                  inActiveIcon: 'assets/svg/favourites_inactive.svg',
                  title: S.of(context).favourites),
              BottomTab(
                  tabIndex: 3,
                  activeIcon: 'assets/svg/more_active.svg',
                  inActiveIcon: 'assets/svg/more_inactive.svg',
                  title: S.of(context).more)
            ],
          ),
        ),
      ),
    );
  }
}

class BottomTab extends StatelessWidget {
  const BottomTab({
    super.key,
    required this.tabIndex,
    required this.activeIcon,
    required this.inActiveIcon,
    required this.title,
  });
  final String activeIcon, inActiveIcon, title;
  final int tabIndex;

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      return Expanded(
          child: InkWell(
        onTap: () {
          ref.watch(homeTabControllerProvider.notifier).state = tabIndex;
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                ref.watch(homeTabControllerProvider) == tabIndex
                    ? activeIcon
                    : inActiveIcon,
                width: 24.h,
                height: 24.h,
                color: ref.watch(homeTabControllerProvider) == tabIndex
                    ? colors(context).primaryColor
                    : colors(context).hintTextColor,
              ),
              4.ph,
              Text(
                title,
                style: AppTextStyle(context).bodyTextSmall.copyWith(
                    fontSize: 10.sp,
                    color: ref.watch(homeTabControllerProvider) == tabIndex
                        ? colors(context).primaryColor
                        : colors(context).hintTextColor),
              )
            ],
          ),
        ),
      ));
    });
  }
}
