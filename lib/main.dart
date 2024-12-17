import 'package:eng_alaa_hammed/app.dart';
import 'package:eng_alaa_hammed/core/depandancy_injection/service_locator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
 await setupServiceLocator();
  runApp(MyApp());
}
