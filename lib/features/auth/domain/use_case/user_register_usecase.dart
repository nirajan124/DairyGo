import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/use_case/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/user_entity.dart';
import '../repository/user_repository.dart';


/// ------------------- PARAMS -------------------

class RegisterUserParams extends Equatable {
  final String email;
  final String username;

  final String password;


  const RegisterUserParams({
    required this.email,
    required this.username,

    required this.password,

  });

  @override
  List<Object?> get props => [
        email,
        username,

        password,

      ];
}

/// ------------------- USE CASE -------------------

class UserRegisterUsecase
    implements UsecaseWithParams<void, RegisterUserParams> {
  final IUserRepository _userRepository;

  UserRegisterUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, void>> call(RegisterUserParams params) {
    final user = UserEntity(
      email: params.email,
      username: params.username,

      password: params.password,

    );
    return _userRepository.registerUser(user);
  }
}
