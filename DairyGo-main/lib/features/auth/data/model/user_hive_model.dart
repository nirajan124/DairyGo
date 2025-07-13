import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:uuid/uuid.dart';

import '../../../../app/constants/hive_table_constant.dart';
import '../../domain/entity/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String username;



  @HiveField(3)
  final String password;



  UserHiveModel({
    String? userId,
    required this.email,
    required this.username,

    required this.password,

  }) : userId = userId ?? const Uuid().v4();

  // Initial Constructor
  const UserHiveModel.initial()
      : userId = '',
        email = '',
        username = '',

        password = '';


  // From Entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      email: entity.email,
      username: entity.username,

      password: entity.password,

    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      email: email,
      username: username,

      password: password,

    );
  }

  // Convert List of HiveModels to List of Entities
  static List<UserEntity> toEntityList(List<UserHiveModel> hiveList) {
    return hiveList.map((data) => data.toEntity()).toList();
  }

  // Convert List of Entities to List of HiveModels
  static List<UserHiveModel> fromEntityList(List<UserEntity> entityList) {
    return entityList.map((data) => UserHiveModel.fromEntity(data)).toList();
  }

  @override
  List<Object?> get props =>
      [userId, email, username, password];
}
