import 'package:ready_lms/model/category.dart';
import 'package:ready_lms/model/common/common_response_model.dart';
import 'package:ready_lms/service/category.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryController extends StateNotifier<bool> {
  final Ref ref;
  CategoryController(this.ref) : super(false);
  List<CategoryModel> allCategoryList = [];

  Future<CommonResponse> getCategories({Map<String, dynamic>? query}) async {
    state = true;
    bool isSuccess = false;
    try {
      final response =
          await ref.read(categoryServiceProvider).getCategories(query: query);
      state = false;
      isSuccess = true;
      final List<dynamic> list = response.data['data']['categories'];
      var categoryList =
          list.map((data) => CategoryModel.fromJson(data)).toList();
      allCategoryList = categoryList;
      return CommonResponse(
          isSuccess: isSuccess,
          message: response.data['message'],
          response: categoryList);
    } catch (error) {
      debugPrint(error.toString());
      state = false;
      return CommonResponse(isSuccess: isSuccess, message: error.toString());
    } finally {
      state = false;
    }
  }
}

final categoryController = StateNotifierProvider<CategoryController, bool>(
    (ref) => CategoryController(ref));
