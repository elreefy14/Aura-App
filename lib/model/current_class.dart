import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ready_lms/model/course_detail.dart';

class CurrentPlay {
  int? id, index;
  String? fileLink, fileSystem, fileName;
  Contents? contents;
  StateProvider<bool>? isViewContent;
  CurrentPlay(
      {this.fileName,
      this.fileSystem,
      this.id,
      this.index,
      this.fileLink,
      this.contents,
      this.isViewContent});
}
