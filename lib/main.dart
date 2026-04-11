import 'package:flutter/material.dart';

import 'app.dart';
import 'src/shared/storage/local_storage_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorageBootstrap.init();
  runApp(const ApiFlutterApp());
}
