import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> registerUser(UserModel user);
  Future<UserModel?> authenticateUser(String email, String password);
  Future<UserModel?> getUserByEmail(String email);
  Future<void> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String usersKey = 'users';

  @override
  Future<void> registerUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(usersKey) ?? [];
    
    // Check if user already exists
    for (String userJson in usersJson) {
      final existingUser = UserModel.fromJson(jsonDecode(userJson));
      if (existingUser.email == user.email) {
        throw Exception('User already exists');
      }
    }
    
    usersJson.add(jsonEncode(user.toJson()));
    await prefs.setStringList(usersKey, usersJson);
  }

  @override
  Future<UserModel?> authenticateUser(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(usersKey) ?? [];
    
    for (String userJson in usersJson) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      if (user.email == email && user.password == password) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(usersKey) ?? [];
    
    for (String userJson in usersJson) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      if (user.email == email) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<void> updateUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(usersKey) ?? [];
    final updatedUsersJson = <String>[];
    
    for (String userJson in usersJson) {
      final existingUser = UserModel.fromJson(jsonDecode(userJson));
      if (existingUser.email == user.email) {
        updatedUsersJson.add(jsonEncode(user.toJson()));
      } else {
        updatedUsersJson.add(userJson);
      }
    }
    
    await prefs.setStringList(usersKey, updatedUsersJson);
  }

  @override
  Future<void> deleteUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(usersKey) ?? [];
    final updatedUsersJson = <String>[];
    
    for (String userJson in usersJson) {
      final user = UserModel.fromJson(jsonDecode(userJson));
      if (user.id != userId) {
        updatedUsersJson.add(userJson);
      }
    }
    
    await prefs.setStringList(usersKey, updatedUsersJson);
  }
} 