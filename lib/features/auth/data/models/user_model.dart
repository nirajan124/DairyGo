import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: '_id')
  final String? id;

  @JsonKey(name: 'fname')
  final String firstName;

  @JsonKey(name: 'lname')
  final String lastName;

  final String email;

  final String phone;

  final String? password;

  final String? image;

  final String role;

  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;

  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;

  UserModel({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.password,
    this.image,
    this.role = 'customer',
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['_id']?.toString(),
    firstName: json['fname']?.toString() ?? '',
    lastName: json['lname']?.toString() ?? '',
    email: json['email']?.toString() ?? '',
    phone: json['phone']?.toString() ?? '',
    password: json['password']?.toString(),
    image: json['image']?.toString(),
    role: json['role']?.toString() ?? 'customer',
    createdAt: json['createdAt'] == null ? null : DateTime.tryParse(json['createdAt'].toString()),
    updatedAt: json['updatedAt'] == null ? null : DateTime.tryParse(json['updatedAt'].toString()),
  );

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Getter for full name
  String get fullName => '$firstName $lastName';

  // Copy with method
  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    String? image,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      image: image ?? this.image,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
} 