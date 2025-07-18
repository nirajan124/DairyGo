import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../app/use_case/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/user_repository.dart';


class UserLoginParams extends Equatable {
  final String username;
  final String password;
  

  const UserLoginParams({required this.username, required this.password, required String email});

  // Initial Constructor
  const UserLoginParams.initial() : username = '', password = '';

  @override
  List<Object?> get props => [username, password];
}

class UserLoginUsecase implements UsecaseWithParams<String, UserLoginParams> {
  final IUserRepository _userRepository;

  UserLoginUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(UserLoginParams params) async {
    return await _userRepository.loginUser(
      params.username,
      params.password,
    );
  }
}
