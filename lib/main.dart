import 'package:flutter/material.dart';
<<<<<<< HEAD

import 'app/app.dart';
import 'app/service_locator/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/auth/presentation/view/View/login.dart';
import 'features/home/presentation/view/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DairyGo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomePage(),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  Future<bool> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return token != null && token.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkSession(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.data == true) {
          Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
        } else {
          Future.microtask(() => Navigator.pushReplacementNamed(context, '/login'));
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
=======
import 'package:hive_flutter/hive_flutter.dart';
import 'features/auth/data/models/user_model.dart';
import 'core/di/injection_container.dart' as di;
import 'app.dart';

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
  
  runApp(const DairyGoApp());
}
>>>>>>> master
