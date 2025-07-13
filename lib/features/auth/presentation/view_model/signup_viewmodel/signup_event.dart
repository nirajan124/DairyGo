import 'package:flutter/material.dart';

abstract class SignupEvent {}

class SignupButtonPressed extends SignupEvent {
  final String email;
  final String username;
  final String password;
  final BuildContext context;

  SignupButtonPressed({
    required this.email,
    required this.username,
    required this.password,
    required this.context,
  });
}
