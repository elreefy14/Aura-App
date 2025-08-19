import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/blog/blog_details_model.dart';
import 'package:ready_lms/model/blog/blog_model.dart';
import 'package:ready_lms/service/blog.dart';

class BlogController extends StateNotifier<AsyncValue<BlogModel>> {
  final Ref ref;

  BlogController(this.ref) : super(const AsyncLoading()) {
    getBlogList();
  }

  Future<void> getBlogList({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    try {
      if (page == 1) state = const AsyncLoading();
      final response = await ref.read(blogServiceProvider).getBlogs(
            page: page,
            perPage: perPage,
            search: search,
          );

      // Parse the new data
      var newData = BlogModel.fromJson(response.data);

      // Combine old blogs with new blogs
      var currentBlogs = state.value?.data.blogs ?? [];
      var updatedBlogs = [...currentBlogs, ...newData.data.blogs];
      // Update the state with the new data
      state = AsyncData(
        newData.copyWith(
          data: newData.data.copyWith(blogs: updatedBlogs),
        ),
      );
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final blogListControllerProvider =
    StateNotifierProvider<BlogController, AsyncValue<BlogModel>>(
  (ref) => BlogController(ref),
);

class BlogDetailsController
    extends StateNotifier<AsyncValue<BlogDetailsModel>> {
  final Ref ref;
  final int blogId;

  BlogDetailsController({
    required this.ref,
    required this.blogId,
  }) : super(const AsyncLoading()) {
    getBlogDetails(blogId: blogId);
  }

  Future<void> getBlogDetails({required int blogId}) async {
    try {
      state = const AsyncLoading();
      final response =
          await ref.read(blogServiceProvider).getBlogDetailsById(id: blogId);
      state = AsyncData(BlogDetailsModel.fromJson(response.data));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow;
    }
  }
}

final blogDetailsControllerProvider = StateNotifierProvider.family<
    BlogDetailsController, AsyncValue<BlogDetailsModel>, int>(
  (ref, blogId) => BlogDetailsController(
    ref: ref,
    blogId: blogId,
  ),
);
