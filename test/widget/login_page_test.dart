import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dairygo/features/auth/presentation/view/login_page.dart';
import 'package:dairygo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dairygo/features/auth/domain/entities/user_entity.dart';
import 'package:dairygo/features/auth/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  Future<Either<String, UserEntity>> login(String email, String password) async => Left('Not implemented');
  @override
  Future<Either<String, UserEntity>> register(UserEntity user, String password) async => Left('Not implemented');
  @override
  Future<Either<String, void>> logout() async => Right(null);
  @override
  Future<bool> isLoggedIn() async => false;
  @override
  Future<Either<String, UserEntity>> getCurrentUser() async => Left('Not implemented');
  @override
  Future<Either<String, UserEntity>> updateProfile(UserEntity user) async => Left('Not implemented');
}

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc(authRepository: FakeAuthRepository());
  });

  tearDown(() {
    authBloc.close();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AuthBloc>.value(
        value: authBloc,
        child: const LoginPage(),
      ),
    );
  }

  group('LoginPage Widget Tests', () {
    // Test 1: Widget renders correctly
    testWidgets('should render login page with basic elements', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    // Test 2: Text fields exist
    testWidgets('should have text fields for user input', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(TextField), findsNWidgets(2));
    });

    // Test 3: Button exists
    testWidgets('should have a login button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Login'), findsOneWidget);
    });

    // Test 4: Text input works
    testWidgets('should allow text input in fields', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'test@example.com');
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);
    });

    // Test 5: Multiple text inputs
    testWidgets('should handle multiple text inputs', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'test@example.com');
      await tester.enterText(textFields.at(1), 'password123');
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('password123'), findsOneWidget);
    });

    // Test 6: Button interaction
    testWidgets('should have interactive button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      final loginButton = find.text('Login');
      expect(loginButton, findsOneWidget);
      await tester.tap(loginButton);
      await tester.pump();
    });

    // Test 7: Form structure
    testWidgets('should have proper form structure', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(Container), findsWidgets);
      expect(find.byType(BlocConsumer<AuthBloc, AuthState>), findsOneWidget);
    });

    // Test 8: Sign up link exists
    testWidgets('should have sign up link', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
    });

    // Test 9: Forgot password link exists
    testWidgets('should have forgot password link', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    // Test 10: Navigation elements
    testWidgets('should have navigation elements', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.byType(TextButton), findsNWidgets(2));
    });
  });
} 