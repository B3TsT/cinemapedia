import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/config/constants/environment.dart';

Future<void> main() async {
  await Environment.loadFileName;
  runApp(const MainApp());
}
