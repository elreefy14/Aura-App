import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTabService {
  final Ref ref;
  HomeTabService(this.ref);

  // Future<List<MyFlavour>> getAllFlavours() async {
  //   final response =
  //       await ref.read(apiClientProvider).get(AppConstant.notifications);
  //   final List<dynamic> data = response.data['data']['notifications'];
  //   final List<MyFlavour> dataList =
  //       data.map((banner) => MyFlavour.fromJson(banner)).toList();
  // }
}

final homeTabService = Provider((ref) => HomeTabService(ref));
