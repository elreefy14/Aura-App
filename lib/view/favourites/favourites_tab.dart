import 'package:ready_lms/components/busy_loader.dart';
import 'package:ready_lms/components/shimmer.dart';
import 'package:ready_lms/controllers/favourites_tab.dart';
import 'package:ready_lms/model/course_list.dart';
import 'package:ready_lms/view/favourites/component/favorite_card.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteTab extends ConsumerStatefulWidget {
  const FavouriteTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyOrderViewState();
}

class _MyOrderViewState extends ConsumerState<FavouriteTab> {
  ScrollController scrollController = ScrollController();
  bool hasMoreData = true;
  int currentPage = 1;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init(isRefresh: true);
    });
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (hasMoreData) init();
      }
    });
  }

  Future<void> init({bool isRefresh = false}) async {
    await ref
        .read(favouriteTabController.notifier)
        .getFavouriteList(isRefresh: isRefresh, currentPage: currentPage)
        .then(
      (value) {
        if (value.isSuccess) {
          if (value.response) {
            currentPage++;
          }
          hasMoreData = value.response;
          if (!hasMoreData) {
            setState(() {});
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = ref.watch(favouriteTabController).isLoading;
    List<CourseListModel> courseList =
        ref.watch(favouriteTabController).courseList;
    return Scaffold(
      appBar: ApGlobalFunctions.cAppBar(header: Text(S.of(context).favourites)),
      body: RefreshIndicator(
        onRefresh: () async {
          hasMoreData = true;
          currentPage = 1;
          init(isRefresh: true);
        },
        child: SafeArea(
            child: isLoading && currentPage == 1
                ? const ShimmerWidget()
                : !isLoading && courseList.isEmpty
                    ? ApGlobalFunctions.noItemFound(context: context)
                    : SingleChildScrollView(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            16.ph,
                            ...List.generate(
                                courseList.length + 1,
                                (index) => index < courseList.length
                                    ? FavoriteCard(
                                        canEnroll:
                                            !courseList[index].isEnrolled,
                                        onTap: () {
                                          ref
                                              .read(favouriteTabController
                                                  .notifier)
                                              .favouriteUpdate(
                                                  id: courseList[index].id)
                                              .then((value) {
                                            if (value.isSuccess) {
                                              courseList.removeAt(index);
                                              setState(() {});
                                            }
                                          });
                                        },
                                        model: courseList[index],
                                      )
                                    : hasMoreData && courseList.length >= 6
                                        ? SizedBox(
                                            height: 80.h,
                                            child: const BusyLoader())
                                        : Container())
                          ],
                        ),
                      )),
      ),
    );
  }
}
