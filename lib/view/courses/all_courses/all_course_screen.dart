import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/course_card.dart';
import 'package:ready_lms/components/drop_down_item.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/category.dart';
import 'package:ready_lms/controllers/courses/course.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/category.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/courses/all_courses/component/filter_bottom_widget.dart';
import 'package:ready_lms/view/courses/all_courses/component/sort_by_bottom_widget.dart';

class AllCourseScreen extends ConsumerStatefulWidget {
  const AllCourseScreen(
      {super.key, required this.categoryModel, this.showMostPopular = false});
  final CategoryModel? categoryModel;
  final bool showMostPopular;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllCourseViewState();
}

class _AllCourseViewState extends ConsumerState<AllCourseScreen> {
  bool isPrepareShortFilter = false;
  final loadingMore = StateProvider<bool>((ref) {
    return false;
  });
  bool hasMoreData = true;
  int currentPage = 1;
  final isDropDownShow = StateProvider<bool>((ref) {
    return false;
  });
  List<CategoryModel> categoryList = [];
  CategoryModel? selectedCategory;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      categoryList.add(CategoryModel(title: 'All'));
      categoryList
          .addAll(ref.read(categoryController.notifier).allCategoryList);
      selectedCategory = widget.categoryModel ?? categoryList[0];
      loadData(isRefresh: true);
    });
  }

  Future<void> loadData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMoreData = true;
    }
    await ref
        .read(courseController.notifier)
        .getAllCourse(isRefresh: isRefresh, currentPage: currentPage, query: {
      if (widget.showMostPopular) 'sort': 'view_count',
      if (selectedCategory!.id != null) 'category_id': selectedCategory!.id
    }).then((value) {
      if (value.isSuccess) {
        if (value.response) {
          currentPage++;
        }
        hasMoreData = value.response;
        if (!hasMoreData) {
          if (mounted) setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (!isPrepareShortFilter) {
    //   ApGlobalFunctions.prepareShortAndFilterData(context);
    //   isPrepareShortFilter = true;
    // }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).course,
          maxLines: 1,
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.nav.pushNamed(Routes.courseSearchScreen);
            },
            child: SvgPicture.asset(
              'assets/svg/ic_search.svg',
              height: 24.h,
              width: 24.h,
              color: colors(context).titleTextColor,
            ),
          ),
          12.pw,
          GestureDetector(
            onTap: () => {
              ApGlobalFunctions.showBottomSheet(
                  context: context,
                  widget: SortByBottomWidget(() {
                    loadData(isRefresh: true);
                  }))
            },
            child: SvgPicture.asset(
              'assets/svg/ic_sort.svg',
              height: 19.h,
              width: 19.h,
              color: colors(context).titleTextColor,
            ),
          ),
          12.pw,
          GestureDetector(
            onTap: () {
              ApGlobalFunctions.showBottomSheet(
                  context: context,
                  widget: FilterBottomWidget(() {
                    loadData(isRefresh: true);
                  }));
            },
            child: SvgPicture.asset(
              'assets/svg/ic_filter.svg',
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
      body: GestureDetector(
        onTap: () {
          if (ref.read(isDropDownShow)) {
            ref.read(isDropDownShow.notifier).state = false;
          }
        },
        child: ref.watch(courseController).isListLoading && currentPage == 1
            ? const ShimmerWidget()
            : Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ref.watch(courseController).courseList.isEmpty
                            ? Center(
                                child: Text(
                                S.of(context).noDataFound,
                              ))
                            : Positioned.fill(
                                top: 50.h,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      16.ph,
                                      Column(
                                        children: [
                                          ...List.generate(
                                            ref
                                                .watch(courseController)
                                                .courseList
                                                .length,
                                            (index) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.h),
                                              child: CourseCard(
                                                model: ref
                                                    .read(courseController)
                                                    .courseList[index],
                                                marginBottom: 15,
                                                width: double.infinity,
                                                height: 160,
                                                onTap: () {
                                                  if (ref
                                                      .read(courseController)
                                                      .courseList[index]
                                                      .isEnrolled) {
                                                    context.nav.pushNamed(
                                                        Routes.myCourseDetails,
                                                        arguments: ref
                                                            .read(
                                                                courseController)
                                                            .courseList[index]
                                                            .id);
                                                  } else {
                                                    context.nav.pushNamed(
                                                        Routes.courseNew,
                                                        arguments: {
                                                          'courseId': ref
                                                              .read(
                                                                  courseController)
                                                              .courseList[index]
                                                              .id,
                                                        });
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          if (ref
                                                  .watch(courseController)
                                                  .courseList
                                                  .isNotEmpty &&
                                              hasMoreData &&
                                              ref
                                                      .watch(courseController)
                                                      .courseList
                                                      .length >
                                                  9)
                                            GestureDetector(
                                              onTap: () async {
                                                ref
                                                    .read(loadingMore.notifier)
                                                    .state = true;
                                                await loadData();
                                                ref
                                                    .read(loadingMore.notifier)
                                                    .state = false;
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 54.h,
                                                    vertical: 12.h),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            48.r),
                                                    color:
                                                        context.color.surface),
                                                child: ref.watch(loadingMore)
                                                    ? SizedBox(
                                                        width: 18.h,
                                                        height: 18.h,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  context.color
                                                                      .primary),
                                                        ),
                                                      )
                                                    : Text(
                                                        S.of(context).loadMore,
                                                        style: AppTextStyle(
                                                                context)
                                                            .bodyTextSmall,
                                                      ),
                                              ),
                                            ),
                                          32.ph
                                        ],
                                      ),
                                      16.ph
                                    ],
                                  ),
                                )),
                        if (selectedCategory != null)
                          Container(
                            margin: EdgeInsets.only(top: 1.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.h, vertical: 16.h),
                            color: context.color.surface,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedCategory!.title!,
                                    style: AppTextStyle(context).bodyTextSmall,
                                  ),
                                ),
                                4.pw,
                                GestureDetector(
                                  onTap: () {
                                    ref.read(isDropDownShow.notifier).state =
                                        !ref.read(isDropDownShow);
                                  },
                                  child: Icon(
                                    ref.watch(isDropDownShow)
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded,
                                    color: context.color.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (ref.watch(isDropDownShow))
                          Positioned(
                            top: 58.h,
                            left: 0,
                            right: 0,
                            child: Container(
                                constraints:
                                    const BoxConstraints(maxHeight: 400),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r)),
                                width: MediaQuery.of(context).size.width - 24,
                                child: ListView.builder(
                                    itemCount: categoryList.length,
                                    itemBuilder: (context, index) => Container(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.h),
                                            child: DropDownItem(
                                              isTopItem: index == 0,
                                              isBottomItem: index ==
                                                  categoryList.length - 1,
                                              onTap: () {
                                                selectedCategory =
                                                    categoryList[index];
                                                ref
                                                    .read(
                                                        isDropDownShow.notifier)
                                                    .state = false;
                                                loadData(isRefresh: true);
                                                setState(() {});
                                              },
                                              title:
                                                  "${categoryList[index].title!} ${index == 0 ? "" : "(${categoryList[index].courseCount})"}",
                                              isSelected: categoryList[index] ==
                                                  selectedCategory,
                                            ),
                                          ),
                                        ))),
                          )
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
