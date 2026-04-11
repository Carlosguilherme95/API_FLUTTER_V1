import 'package:hive_flutter/hive_flutter.dart';

import 'storage_boxes.dart';

abstract final class LocalStorageBootstrap {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(StorageBoxes.app);
  }
}
