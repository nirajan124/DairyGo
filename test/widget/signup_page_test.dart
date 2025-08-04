import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dairygo/features/auth/presentation/view/signup_page.dart';
import 'package:dairygo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dairygo/features/auth/domain/repositories/auth_repository.dart';
import 'package:dairygo/features/auth/domain/entities/user_entity.dart';

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
        child: const SignUpPage(),
      ),
    );
  }

  group('SignUpPage Widget Tests', () {
    // Test 1: Widget renders correctly
    testWidgets('should render signup page with basic elements', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Stack), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(5));
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    // Test 2: Text fields exist
    testWidgets('should have text fields for user input', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextField), findsNWidgets(5));
    });

    // Test 3: Button exists
    testWidgets('should have a sign up button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Sign Up'), findsOneWidget);
    });

    // Test 4: Text input works
    testWidgets('should allow text input in fields', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(5));

      // Enter text in first field
      await tester.enterText(textFields.first, 'John');
      await tester.pump();

      expect(find.text('John'), findsOneWidget);
    });

    // Test 5: Multiple text inputs
    testWidgets('should handle multiple text inputs', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final textFields = find.byType(TextField);
      
      await tester.enterText(textFields.at(0), 'John');
      await tester.enterText(textFields.at(1), 'Doe');
      await tester.enterText(textFields.at(2), 'test@example.com');
      await tester.pump();

      expect(find.text('John'), findsOneWidget);
      expect(find.text('Doe'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
    });

    // Test 6: Button interaction
    testWidgets('should have interactive button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final signUpButton = find.text('Sign Up');
      expect(signUpButton, findsOneWidget);
      
      await tester.tap(signUpButton);
      await tester.pump();
    });

    // Test 7: Form structure
    testWidgets('should have proper form structure', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(BlocConsumer<AuthBloc, AuthState>), findsOneWidget);
    });

    // Test 8: Login link exists
    testWidgets('should have login link', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
    });

    // Test 9: Backend test button
    testWidgets('should have backend test button', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Test Backend Connection'), findsOneWidget);
    });

    // Test 10: Widget hierarchy
    testWidgets('should have correct widget hierarchy', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(BlocProvider<AuthBloc>), findsOneWidget);
    });

    // Test 11: Text field labels
    testWidgets('should have text field labels', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    // Test 12: Form validation
    testWidgets('should handle empty form submission', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Should still have the form
      expect(find.byType(TextField), findsNWidgets(5));
    });

    // Test 13: Text clearing
    testWidgets('should clear text fields', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Test');
      await tester.pump();

      expect(find.text('Test'), findsOneWidget);

      await tester.enterText(textFields.first, '');
      await tester.pump();

      expect(find.text('Test'), findsNothing);
    });

    // Test 14: Button state
    testWidgets('should have enabled button initially', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final signUpButton = find.text('Sign Up');
      expect(signUpButton, findsOneWidget);
    });

    // Test 15: Navigation elements
    testWidgets('should have navigation elements', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextButton), findsOneWidget); // Login button
      expect(find.byType(ElevatedButton), findsNWidgets(2)); // Sign Up and Test Backend Connection
      expect(find.byType(Row), findsWidgets);
    });
  });
} 