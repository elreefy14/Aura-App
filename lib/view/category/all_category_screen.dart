import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/category_card.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/category.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/category.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';

class AllCategoryScreen extends ConsumerStatefulWidget {
  const AllCategoryScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllCourseViewState();
}

class _AllCourseViewState extends ConsumerState<AllCategoryScreen> {
  List<CategoryModel> categoryList = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadData();
    });
  }

  Future<void> loadData({bool isRefresh = false}) async {
    ref.read(categoryController.notifier).getCategories().then(
      (value) {
        if (value.isSuccess) {
          categoryList.addAll(value.response);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.color.surface,
        appBar: AppBar(
          title: Text(
            S.of(context).allCategories,
            maxLines: 1,
          ),
          actions: [
            GestureDetector(
              onTap: () {
                context.nav.pushNamed(Routes.categorySearchScreen);
              },
              child: SvgPicture.asset(
                'assets/svg/ic_search.svg',
                height: 19.h,
                width: 19.h,
                color: colors(context).titleTextColor,
              ),
            ),
            20.pw
          ],
          leading: IconButton(
              onPressed: () {
                context.nav.pop();
              },
              icon: SvgPicture.asset(
                'assets/svg/ic_arrow_left.svg',
                width: 24.h,
                height: 24.h,
                color: context.color.onSurface,
              )),
        ),
        body: ref.watch(categoryController)
            ? const ShimmerWidget()
            : Column(
                children: [
                  Divider(
                    color: colors(context).scaffoldBackgroundColor,
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(20.h),
                      shrinkWrap: true,
                      itemCount: categoryList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 4.h,
                          mainAxisSpacing: 12.h,
                          crossAxisCount: 2,
                          childAspectRatio: 1.17.h),
                      itemBuilder: (context, index) => CategoryCard(
                          image: categoryList[index].image ??
                              AppConstants.defaultAvatarImageUrl,
                          width: double.infinity,
                          title: categoryList[index].title ?? "Demo",
                          totalCourse: categoryList[index].courseCount ?? 0,
                          color: categoryList[index].color!.toColor(),
                          onTap: () {
                            context.nav.pushNamed(Routes.allCourseScreen,
                                arguments: {'model': categoryList[index]});
                          }),
                    ),
                  )
                ],
              ));
  }
}
