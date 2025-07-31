import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/service_locator/service_locator.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();
  
  await setupServiceLocator();
  runApp(const DairyGoApp());
}
