import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/cart/presentation/cart_cubit.dart';
import 'features/orders/presentation/orders_cubit.dart';
import 'features/payment/presentation/payment_cubit.dart';
import 'features/home/presentation/view/dashboard_page.dart';
import 'features/auth/presentation/view/login_page.dart';
import 'features/auth/presentation/view/signup_page.dart';

class DairyGoApp extends StatelessWidget {
  const DairyGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: di.sl()),
        ),
        BlocProvider<CartCubit>(
          create: (context) => di.sl<CartCubit>(),
        ),
        BlocProvider<OrdersCubit>(
          create: (context) => OrdersCubit(),
        ),
        BlocProvider<PaymentCubit>(
          create: (context) => PaymentCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Dairy Go',
        theme: ThemeData(
          primarySwatch: Colors.orange,
          fontFamily: 'Opensans Regular',
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check authentication status when app starts
    context.read<AuthBloc>().add(CheckAuthStatus());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print('AuthWrapper state: $state'); // Debug logging
        
        if (state is Authenticated) {
          print('User authenticated: ${state.user}');
          return const DashboardPage();
        } else if (state is AuthLoading) {
          print('Auth loading...');
          return Scaffold(
            backgroundColor: Color(0xFF181C2E),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state is AuthError) {
          print('Auth error: ${state.message}');
          return Scaffold(
            backgroundColor: Color(0xFF181C2E),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'Authentication Error',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(CheckAuthStatus());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        } else {
          print('User not authenticated, showing login page');
          return const LoginPage();
        }
      },
    );
  }
}