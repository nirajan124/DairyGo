import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:dairygo/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dairygo/features/auth/domain/entities/user_entity.dart';
import 'package:dairygo/features/auth/domain/repositories/auth_repository.dart';
import 'auth_bloc_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthBloc authBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    final testUser = UserEntity(
      id: '1',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      phone: '1234567890',
      image: 'profile.jpg',
    );

    final testFailure = 'Authentication failed';

    // Test 1: Initial state
    test('should have initial state of AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    // Test 2: Login success
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, Authenticated] when login is successful',
      build: () {
        when(mockAuthRepository.login('test@example.com', 'password'))
            .thenAnswer((_) async => Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('test@example.com', 'password')),
      expect: () => [
        isA<AuthLoading>(),
        isA<Authenticated>(),
      ],
      verify: (bloc) {
        verify(mockAuthRepository.login('test@example.com', 'password')).called(1);
      },
    );

    // Test 3: Login failure
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when login fails',
      build: () {
        when(mockAuthRepository.login('test@example.com', 'wrongpassword'))
            .thenAnswer((_) async => Left(testFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('test@example.com', 'wrongpassword')),
      expect: () => [
        isA<AuthLoading>(),
        AuthError(testFailure),
      ],
      verify: (bloc) {
        verify(mockAuthRepository.login('test@example.com', 'wrongpassword')).called(1);
      },
    );

    // Test 4: Register success
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, Unauthenticated] when register is successful',
      build: () {
        when(mockAuthRepository.register(testUser, 'password'))
            .thenAnswer((_) async => Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterRequested(testUser, 'password')),
      expect: () => [
        isA<AuthLoading>(),
        isA<Unauthenticated>(),
      ],
      verify: (bloc) {
        verify(mockAuthRepository.register(testUser, 'password')).called(1);
      },
    );

    // Test 5: Register failure
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, AuthError] when register fails',
      build: () {
        when(mockAuthRepository.register(testUser, 'password'))
            .thenAnswer((_) async => Left(testFailure));
        return authBloc;
      },
      act: (bloc) => bloc.add(RegisterRequested(testUser, 'password')),
      expect: () => [
        isA<AuthLoading>(),
        AuthError(testFailure),
      ],
      verify: (bloc) {
        verify(mockAuthRepository.register(testUser, 'password')).called(1);
      },
    );

    // Test 6: Logout success
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthLoading, Unauthenticated] when logout is successful',
      build: () {
        when(mockAuthRepository.logout())
            .thenAnswer((_) async => const Right(null));
        return authBloc;
      },
      act: (bloc) => bloc.add(LogoutRequested()),
      expect: () => [
        isA<AuthLoading>(),
        isA<Unauthenticated>(),
      ],
      verify: (bloc) {
        verify(mockAuthRepository.logout()).called(1);
      },
    );

    // Test 7: Check auth status - user logged in
    blocTest<AuthBloc, AuthState>(
      'should emit [Authenticated] when user is logged in',
      build: () {
        when(mockAuthRepository.isLoggedIn())
            .thenAnswer((_) async => true);
        when(mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckAuthStatus()),
      expect: () => [
        isA<Authenticated>(),
      ],
      verify: (bloc) {
        verify(mockAuthRepository.isLoggedIn()).called(1);
        verify(mockAuthRepository.getCurrentUser()).called(1);
      },
    );

    // Test 8: Check auth status - user not logged in
    blocTest<AuthBloc, AuthState>(
      'should emit [Unauthenticated] when user is not logged in',
      build: () {
        when(mockAuthRepository.isLoggedIn())
            .thenAnswer((_) async => false);
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckAuthStatus()),
      expect: () => [
        isA<Unauthenticated>(),
      ],
      verify: (bloc) {
        verify(mockAuthRepository.isLoggedIn()).called(1);
        verifyNever(mockAuthRepository.getCurrentUser());
      },
    );

    // Test 9: Refresh user data success
    blocTest<AuthBloc, AuthState>(
      'should emit [Authenticated] when refresh user data is successful',
      build: () {
        when(mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => Right(testUser));
        return authBloc;
      },
      act: (bloc) => bloc.add(RefreshUserDataRequested()),
      expect: () => [
        isA<Authenticated>(),
      ],
      verify: (bloc) {
        verify(mockAuthRepository.getCurrentUser()).called(1);
      },
    );

    // Test 10: Auth reset
    blocTest<AuthBloc, AuthState>(
      'should emit [AuthInitial] when auth reset is requested',
      build: () => authBloc,
      act: (bloc) => bloc.add(AuthResetRequested()),
      expect: () => [
        isA<AuthInitial>(),
      ],
    );
  });
} 