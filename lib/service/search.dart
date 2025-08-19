import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchService {
  final Ref ref;
  SearchService(this.ref);

  // Future<List<MyFlavour>> getAllFlavours() async {
  //   final response =
  //       await ref.read(apiClientProvider).get(AppConstant.notifications);
  //   final List<dynamic> data = response.data['data']['notifications'];
  //   final List<MyFlavour> dataList =
  //       data.map((banner) => MyFlavour.fromJson(banner)).toList();
  // }
}

final searchServiceProvider = Provider((ref) => SearchService(ref));
