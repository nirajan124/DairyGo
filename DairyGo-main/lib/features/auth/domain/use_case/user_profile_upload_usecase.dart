import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../app/use_case/use_case.dart';
import '../../../../core/error/failure.dart';
import '../repository/user_repository.dart';

class UserUploadProfilePictureParams {
  final File file;

  const UserUploadProfilePictureParams({required this.file});
}

class UserUploadProfilePictureUsecase
    implements UsecaseWithParams<String, UserUploadProfilePictureParams> {
  final IUserRepository _userRepository;

  UserUploadProfilePictureUsecase({required IUserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(UserUploadProfilePictureParams params) {
    return _userRepository.uploadProfilePicture(params.file);
  }
}
