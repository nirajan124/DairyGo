// login_event.dart
import 'package:flutter/material.dart';

abstract class LoginEvent {}

class LoginUserEvent extends LoginEvent {
  final String email;
  final String password;
  final BuildContext context;

  LoginUserEvent({
    required this.email,
    required this.password,
    required this.context,
  });
}

class NavigateToSignUpEvent extends LoginEvent {
  final BuildContext context;

  NavigateToSignUpEvent({required this.context});
}
