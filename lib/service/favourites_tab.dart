import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/service/base_service/favourite.dart';
import 'package:ready_lms/utils/api_client.dart';
import 'package:dio/src/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouriteTabService extends Favourite {
  final Ref ref;
  FavouriteTabService(this.ref);

  @override
  Future<Response> getFavouriteList(
      {String? guestId, required int currentPage, int? parPage}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.favouriteList, query: {
      'guest_id': guestId,
      AppConstants.page: '$currentPage',
      AppConstants.perPage: '$parPage'
    });
    return response;
  }

  @override
  Future<Response> FavouriteUpdate(
      {required int courseId, String? guestId}) async {
    final response = await ref.read(apiClientProvider).post(
        AppConstants.favouriteUpdate + courseId.toString(),
        data: {'guest_id': guestId});
    return response;
  }
}

final favouriteTabServiceProvider = Provider((ref) => FavouriteTabService(ref));
