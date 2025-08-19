import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/service/base_service/category.dart';
import 'package:ready_lms/utils/api_client.dart';
import 'package:dio/src/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryServiceProvider extends Category {
  final Ref ref;
  CategoryServiceProvider(this.ref);

  @override
  Future<Response> getCategories({Map<String, dynamic>? query}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.categories, query: query);
    return response;
  }

  // Future<List<MyFlavour>> getAllFlavours() async {
  //   final response =
  //       await ref.read(apiClientProvider).get(AppConstant.notifications);
  //   final List<dynamic> data = response.data['data']['notifications'];
  //   final List<MyFlavour> dataList =
  //       data.map((banner) => MyFlavour.fromJson(banner)).toList();
  // }
}

final categoryServiceProvider = Provider((ref) => CategoryServiceProvider(ref));
