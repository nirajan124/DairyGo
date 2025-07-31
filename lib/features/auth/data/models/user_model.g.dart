// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['_id'] as String?,
      firstName: json['fname'] as String,
      lastName: json['lname'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      password: json['password'] as String?,
      image: json['image'] as String?,
      role: json['role'] as String? ?? 'customer',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      '_id': instance.id,
      'fname': instance.firstName,
      'lname': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'image': instance.image,
      'role': instance.role,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
