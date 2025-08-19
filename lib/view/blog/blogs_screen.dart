import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/utils/context_less_nav.dart';

import '../../components/form_widget.dart';
import '../../config/theme.dart';
import '../../controllers/blog/blog_controller.dart';
import 'widgets/blog_card.dart';

class BlogsScreen extends StatelessWidget {
  BlogsScreen({super.key});

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).blogs,
            maxLines: 1,
          ),
        ),
        body: Column(
          children: [
            _Headerwidget(
              isDark: isDark,
              searchController: searchController,
            ),
            const _BlogListWidget()
          ],
        ),
      ),
    );
  }
}

class _Headerwidget extends ConsumerWidget {
  const _Headerwidget({
    required this.isDark,
    required this.searchController,
  });

  final bool isDark;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: context.color.surface,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF3F4F6),
          ),
        ),
      ),
      child: CustomFormWidget(
        controller: searchController,
        fillColor: Colors.red,
        hint: S.of(context).searchBlog,
        onChanged: (value) {
          pageCount = 1;

          ref.read(blogListControllerProvider.notifier).getBlogList(
              page: pageCount, perPage: perPageBlogs, search: value);
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
    );
  }
}

class _BlogListWidget extends ConsumerStatefulWidget {
  const _BlogListWidget();

  @override
  ConsumerState<_BlogListWidget> createState() => _BlogListWidgetState();
}

class _BlogListWidgetState extends ConsumerState<_BlogListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  _scrollListener() {
    final blogListState = ref.watch(blogListControllerProvider);

    // Ensure we are not already loading or there are no more pages to load
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !(blogListState is AsyncLoading && blogListState.value != null)) {
      final totalBlogs = blogListState.value?.data.totalBlogs;
      final totalPages = (totalBlogs! / perPageBlogs).ceil();
      if (pageCount < totalPages) {
        pageCount++;
        ref.read(blogListControllerProvider.notifier).getBlogList(
              page: pageCount,
              perPage: perPageBlogs,
            );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogListState = ref.watch(blogListControllerProvider);
    return Expanded(
        child: blogListState.when(
      data: (blogsData) => RefreshIndicator(
        onRefresh: () async {
          pageCount = 1;
          ref.read(blogListControllerProvider.notifier).getBlogList(
                page: pageCount,
                perPage: perPageBlogs,
              );
        },
        child: blogsData.data.blogs.isEmpty
            ? Center(child: Text(S.of(context).noBlog))
            : ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(top: 16.h),
                shrinkWrap: true,
                itemCount: blogsData.data.blogs.length,
                itemBuilder: (context, index) => BlogCardWidget(
                  blog: blogsData.data.blogs[index],
                ),
              ),
      ),
      error: (error, stackTrace) => Text(error.toString()),
      loading: () => const Center(child: CircularProgressIndicator()),
    ));
  }
}

int pageCount = 1;
int perPageBlogs = 20;
