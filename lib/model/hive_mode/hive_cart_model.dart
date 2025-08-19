import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'hive_cart_model.g.dart';

@HiveType(typeId: 1)
class HiveCartModel extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? fileExtension;
  @HiveField(2)
  String? uniqueNumber;
  @HiveField(3)
  Uint8List? data;
  @HiveField(4)
  String? fileName;

  HiveCartModel(
      {this.id,
      this.fileExtension,
      this.uniqueNumber,
      this.data,
      this.fileName});
}
