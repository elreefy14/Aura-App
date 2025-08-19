import 'package:dio/src/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_constants.dart';
import '../utils/api_client.dart';
import 'base_service/blog.dart';

class BlogService implements Blog {
  final Ref ref;

  BlogService(this.ref);

  @override
  Future<Response> getBlogs(
      {required int page, required int perPage, String? search}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.blogList, query: {
      'page_number': page,
      'items_per_page': perPage,
      'search': search
    });
    return response;
  }

  @override
  Future<Response> getBlogDetailsById({required int id}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.blogDetail + id.toString());
    return response;
  }
}

final blogServiceProvider = Provider((ref) => BlogService(ref));
