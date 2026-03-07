import 'package:flutter/material.dart';
import 'package:tdd_example/src/core/app/app.dart';
import 'package:tdd_example/src/core/utils/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(App());
}
