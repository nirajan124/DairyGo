import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/service_locator/service_locator.dart';
import '../../../../../core/utils/mysnackbar.dart';
import '../../../../home/presentation/view/HomePage.dart';
import '../../../../home/presentation/view_model/homepage_viewmodel.dart';
import '../../../domain/use_case/user_login_usecase.dart';
import '../../view/View/signup.dart';
import '../signup_viewmodel/signup_viewmodel.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginUsecase _userLoginUsecase;

  LoginViewModel({
    required UserLoginUsecase userLoginUsecase,
  })  : _userLoginUsecase = userLoginUsecase,
        super(LoginState.initial()) {
    on<LoginUserEvent>(_onLoginUser);
    on<NavigateToSignUpEvent>(_onNavigateToSignUp);
  }

  Future<void> _onLoginUser(
      LoginUserEvent event,
      Emitter<LoginState> emit,
      ) async {
    final email = event.email.trim();
    final password = event.password.trim();

    if (email.isEmpty || !email.contains('@')) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Please enter a valid email'));
      showMySnackBar(
        context: event.context,
        message: 'Please enter a valid email',
        color: Colors.red,
      );
      return;
    }

    if (password.isEmpty) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Please enter a password'));
      showMySnackBar(
        context: event.context,
        message: 'Please enter a password',
        color: Colors.red,
      );
      return;
    }

    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: null));

    final result = await _userLoginUsecase.call(
      UserLoginParams(
        email: email,
        password: password,
        username: '',
      ),
    );

    result.fold(
          (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false, errorMessage: failure.message));
        showMySnackBar(
          context: event.context,
          message: failure.message,
          color: Colors.red,
        );
      },
          (user) {
        emit(state.copyWith(isLoading: false, isSuccess: true));
        showMySnackBar(
          context: event.context,
          message: 'Login Successful!',
          color: Colors.green,
        );

        Navigator.of(event.context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (_) => serviceLocator<HomeViewModel>(),
              child: const HomePage(),
            ),
          ),
        );
      },
    );
  }

  void _onNavigateToSignUp(
      NavigateToSignUpEvent event,
      Emitter<LoginState> emit,
      ) {
    Navigator.of(event.context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => serviceLocator<SignupViewModel>(),
          child: SignupScreen(),
        ),
      ),
    );
  }
}
