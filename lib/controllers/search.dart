import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchController extends StateNotifier<bool> {
  final Ref ref;
  SearchController(this.ref) : super(false);

  // Future<List<MyFlavour>?> getAllFlavours() async {
  //   state = true;
  //   try {
  //     final response = await ref.read(myFlavourRepo).getAllFlavours();
  //     return response;
  //   } catch (error) {
  //     state = false;
  //     return null;
  //   } finally {
  //     state = false;
  //   }
  // }
}

final searchController = StateNotifierProvider<SearchController, bool>(
    (ref) => SearchController(ref));
