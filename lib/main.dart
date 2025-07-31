import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'app/service_locator/service_locator.dart';
import 'features/auth/data/models/user_model.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(UserModelAdapter());
  }

  // Clear the usersBox to remove old incompatible data
  await Hive.deleteBoxFromDisk('usersBox');

  // Initialize dependency injection
  await di.init();
  
  await setupServiceLocator();
  runApp(const DairyGoApp());
}
