import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  final UserEntity user;
  final String password;

  RegisterRequested(this.user, this.password);

  @override
  List<Object?> get props => [user, password];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class AuthResetRequested extends AuthEvent {}

class RefreshUserDataRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;

  Authenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<AuthResetRequested>((event, emit) => emit(AuthInitial()));
    on<RefreshUserDataRequested>(_onRefreshUserDataRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await authRepository.login(event.email, event.password);
    
    result.fold(
      (failure) => emit(AuthError(failure)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await authRepository.register(event.user, event.password);
    
    result.fold(
      (failure) => emit(AuthError(failure)),
      (user) => emit(Unauthenticated()),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await authRepository.logout();
    
    result.fold(
      (failure) => emit(AuthError(failure)),
      (_) => emit(Unauthenticated()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    try {
      print('Checking auth status...');
      final isLoggedIn = await authRepository.isLoggedIn();
      print('Is logged in: $isLoggedIn');
      
      if (isLoggedIn) {
        final result = await authRepository.getCurrentUser();
        result.fold(
          (failure) {
            print('Auth error: $failure');
            emit(AuthError(failure));
          },
          (user) {
            print('User authenticated: $user');
            emit(Authenticated(user));
          },
        );
      } else {
        print('User not logged in, showing login page');
        emit(Unauthenticated());
      }
    } catch (e) {
      print('Exception in _onCheckAuthStatus: $e');
      emit(AuthError('Failed to check authentication status: $e'));
    }
  }

  Future<void> _onRefreshUserDataRequested(
    RefreshUserDataRequested event,
    Emitter<AuthState> emit,
  ) async {
    final result = await authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(AuthError(failure)),
      (user) => emit(Authenticated(user)),
    );
  }
} 