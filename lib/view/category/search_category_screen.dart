import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/category_card.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/category.dart';
import 'package:ready_lms/model/category.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';

import '../../generated/l10n.dart';

class CategorySearchScreen extends ConsumerStatefulWidget {
  const CategorySearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchScreenViewState();
}

class _SearchScreenViewState extends ConsumerState<CategorySearchScreen> {
  final categoryController = StateNotifierProvider<CategoryController, bool>(
      (ref) => CategoryController(ref));
  String searchText = '';
  final deBouncer = DeBouncer(milliseconds: 1000);
  final TextEditingController searchController = TextEditingController();
  List<CategoryModel> categoryList = [];
  @override
  void initState() {
    super.initState();
  }

  Future<void> loadData() async {
    categoryList.clear();
    ref
        .read(categoryController.notifier)
        .getCategories(query: {'search': searchText}).then(
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // Set the height to zero
        child: AppBar(
          elevation:
              0, // Optional: Set elevation to zero for a completely flat look
          automaticallyImplyLeading: false, // Optional: Hide the back button
        ),
      ),
      body: Column(
        children: [
          Container(
            color: context.color.surface,
            padding: EdgeInsets.symmetric(vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            context.nav.pop();
                          },
                          icon: SvgPicture.asset(
                            'assets/svg/ic_arrow_left.svg',
                            width: 24.h,
                            height: 24.h,
                            color: context.color.onSurface,
                          )),
                    ],
                  ),
                ),
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(right: 20.h),
                  constraints: BoxConstraints(maxHeight: 44.h),
                  child: CustomFormWidget(
                    controller: searchController,
                    hint: S.of(context).searchCategory,
                    onChanged: (value) {
                      deBouncer.run(() {
                        searchText = value;
                        if (value == '') {
                          categoryList.clear();
                          if (mounted) setState(() {});
                          return;
                        }

                        loadData();
                      });
                    },
                    maxLines: 1,
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(13.h),
                      child: SvgPicture.asset(
                        'assets/svg/ic_search.svg',
                        height: 19.h,
                        width: 19.h,
                        color: colors(context).titleTextColor,
                      ),
                    ),
                  ),
                )),
              ],
            ),
          ),
          Expanded(
            child: ref.watch(categoryController)
                ? const ShimmerWidget()
                : categoryList.isEmpty
                    ? ApGlobalFunctions.noItemFound(context: context)
                    : Container(
                        margin: EdgeInsets.only(top: 1.h),
                        child: Container(
                          color: context.color.surface,
                          child: GridView.builder(
                            padding: EdgeInsets.all(20.h),
                            shrinkWrap: true,
                            itemCount: categoryList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                              },
                            ),
                          ),
                        ),
                      ),
          )
        ],
      ),
    );
  }
}

class DeBouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? _timer;

  DeBouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds!), action);
  }
}
