import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/busy_loader.dart';
import 'package:ready_lms/components/course_card.dart';
import 'package:ready_lms/components/drop_down_item.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/category.dart';
import 'package:ready_lms/controllers/courses/course.dart';
import 'package:ready_lms/model/category.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';

class CourseSearchScreen extends ConsumerStatefulWidget {
  const CourseSearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchScreenViewState();
}

class _SearchScreenViewState extends ConsumerState<CourseSearchScreen> {
  final courseController = StateNotifierProvider<CourseController, Course>(
      (ref) => CourseController(Course(courseList: [], mostPopular: []), ref));
  ScrollController scrollController = ScrollController();
  String searchText = '';

  bool hasMoreData = true;
  int currentPage = 1;
  final deBouncer = DeBouncer(milliseconds: 1000);
  final TextEditingController searchController = TextEditingController();
  final isDropDownShow = StateProvider<bool>((ref) {
    return true;
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
      selectedCategory = categoryList[0];
      setState(() {});
    });

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (hasMoreData) loadData();
      }
    });
  }

  Future<void> loadData({bool isRefresh = false}) async {
    if (isRefresh) {
      currentPage = 1;
      hasMoreData = true;
    }
    ref.read(courseController.notifier).getAllCourse(
        isRefresh: isRefresh,
        currentPage: currentPage,
        makeSortOrFiler: false,
        query: {
          'search': searchText,
          if (selectedCategory?.id != null) 'category_id': selectedCategory!.id
        }).then((value) {
      if (value.isSuccess) {
        if (value.response) {
          currentPage++;
        }
        hasMoreData = value.response;
        if (!hasMoreData) {
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var courseList = ref.watch(courseController).courseList;
    bool isLoading = ref.watch(courseController).isListLoading;

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
                    onChanged: (value) {
                      deBouncer.run(() {
                        searchText = value;
                        if (value == '') {
                          ref.read(courseController.notifier).removeAllCourse();
                          return;
                        }

                        loadData(
                          isRefresh: true,
                        );
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
            child: GestureDetector(
              onTap: () {
                if (ref.read(isDropDownShow)) {
                  ref.read(isDropDownShow.notifier).state = false;
                }
              },
              child: Stack(
                children: [
                  Positioned.fill(
                      top: 50.h,
                      child: isLoading && currentPage == 1
                          ? const ShimmerWidget()
                          : searchText != '' && courseList.isEmpty
                              ? ApGlobalFunctions.noItemFound(context: context)
                              : SingleChildScrollView(
                                  controller: scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      16.ph,
                                      Column(
                                        children: [
                                          ...List.generate(
                                            courseList.length + 1,
                                            (index) => index < courseList.length
                                                ? Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20.h),
                                                    child: CourseCard(
                                                      marginBottom: 15,
                                                      width: double.infinity,
                                                      model: courseList[index],
                                                      height: 160,
                                                      onTap: () {
                                                        if (courseList[index]
                                                            .isEnrolled) {
                                                          context.nav.pushNamed(
                                                              Routes
                                                                  .myCourseDetails,
                                                              arguments:
                                                                  courseList[
                                                                          index]
                                                                      .id);
                                                        } else {
                                                          context.nav.pushNamed(
                                                              Routes.courseNew,
                                                              arguments: {
                                                                'courseId':
                                                                    courseList[
                                                                            index]
                                                                        .id
                                                              });
                                                        }
                                                      },
                                                    ),
                                                  )
                                                : hasMoreData &&
                                                        courseList.length >= 5
                                                    ? SizedBox(
                                                        height: 80.h,
                                                        child:
                                                            const BusyLoader())
                                                    : Container(),
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
                          constraints: const BoxConstraints(maxHeight: 400),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r)),
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                              itemCount: categoryList.length,
                              itemBuilder: (context, index) => Container(
                                    color:
                                        colors(context).scaffoldBackgroundColor,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.h),
                                    child: DropDownItem(
                                      isTopItem: index == 0,
                                      isBottomItem:
                                          index == categoryList.length - 1,
                                      onTap: () {
                                        selectedCategory = categoryList[index];
                                        ref
                                            .read(isDropDownShow.notifier)
                                            .state = false;
                                        if (searchText != '') {
                                          loadData(
                                            isRefresh: true,
                                          );
                                        }
                                        setState(() {});
                                      },
                                      title:
                                          "${categoryList[index].title!} ${index == 0 ? "" : "(${categoryList[index].courseCount})"}",
                                      isSelected: categoryList[index] ==
                                          selectedCategory,
                                    ),
                                  ))),
                    )
                ],
              ),
            ),
          ),
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
