
import 'package:flutter/material.dart';

import '../features/splash/presentation/view/SplashScreenView.dart';
import '../features/auth/presentation/view/View/login.dart';
import '../features/auth/presentation/view/View/signup.dart';
import '../features/home/presentation/view/HomePage.dart';

class DairyGoApp extends StatelessWidget {
  const DairyGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dairy Go',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Opensans Regular',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreenView(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
