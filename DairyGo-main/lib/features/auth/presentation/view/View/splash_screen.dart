
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/service_locator/service_locator.dart';
import '../../../../home/presentation/view/HomePage.dart';
import '../../../../home/presentation/view_model/homepage_viewmodel.dart';
import '../../../../splash/presentation/view_model/splash_viewmodel.dart';
import '../../view_model/login_viewmodel/login_viewmodel.dart';
import 'login.dart';

class SplashScreenView extends StatefulWidget {
  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    context.read<SplashViewModel>().decideNavigation();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashViewModel, SplashState>(
      listener: (context, state) {
        if (state == SplashState.navigateToHome) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<HomeViewModel>(
                create: (_) => serviceLocator<HomeViewModel>(),
                child: const HomePage(),
              ),
            ),
          );
        } else if (state == SplashState.navigateToLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider<LoginViewModel>(
                create: (_) => serviceLocator<LoginViewModel>(),
                child: LoginScreen(),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            // Loading Indicator
            const Center(
              child: CircularProgressIndicator(
                strokeWidth: 6.0,
                color: Colors.white,
              ),
            ),
          ],
        ),



      ),
    );
  }
}