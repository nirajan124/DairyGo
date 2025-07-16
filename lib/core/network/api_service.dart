import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000/api/v1/auth'; // Change to your backend URL

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> register({
    required String fname,
    required String lname,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fname': fname,
        'lname': lname,
        'phone': phone,
        'email': email,
        'password': password,
      }),
    );
    return _processResponse(response);
  }

  Future<Map<String, dynamic>> getProfile(String userId, String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/getCustomer/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final body = _processResponse(response);
    return body['data'] ?? {};
  }

  Future<void> updateProfile({
    required String userId,
    required String token,
    required String fname,
    required String lname,
    required String phone,
    required String email,
    String? imagePath,
  }) async {
    var uri = Uri.parse('$baseUrl/updateCustomer/$userId');
    var request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['fname'] = fname;
    request.fields['lname'] = lname;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    if (imagePath != null) {
      request.files.add(await http.MultipartFile.fromPath('profilePicture', imagePath));
    }
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    _processResponse(response);
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final response = await safeApiCall(() async {
      final res = await http.get(Uri.parse('http://localhost:5000/api/v1/products'));
      return res;
    });
    final body = _processResponse(response);
    if (body['data'] is List) {
      return List<Map<String, dynamic>>.from(body['data']);
    } else {
      return [];
    }
  }

  Future<Map<String, dynamic>> getProductDetail(String productId) async {
    final response = await safeApiCall(() async {
      final res = await http.get(Uri.parse('http://localhost:5000/api/v1/products/$productId'));
      return res;
    });
    final body = _processResponse(response);
    return body['data'] ?? {};
  }

  Future<List<Map<String, dynamic>>> getWishlist(String token) async {
    final response = await safeApiCall(() async {
      final res = await http.get(
        Uri.parse('http://localhost:5000/api/v1/wishlist'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return res;
    });
    final body = _processResponse(response);
    if (body['data'] is List) {
      return List<Map<String, dynamic>>.from(body['data']);
    } else {
      return [];
    }
  }

  Future<void> addToWishlist(String token, String productId) async {
    await safeApiCall(() async {
      final res = await http.post(
        Uri.parse('http://localhost:5000/api/v1/wishlist'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'productId': productId}),
      );
      _processResponse(res);
      return res;
    });
  }

  Future<void> removeFromWishlist(String token, String productId) async {
    await safeApiCall(() async {
      final res = await http.delete(
        Uri.parse('http://localhost:5000/api/v1/wishlist/$productId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      _processResponse(res);
      return res;
    });
  }

  Future<List<Map<String, dynamic>>> getOrders(String token) async {
    final response = await safeApiCall(() async {
      final res = await http.get(
        Uri.parse('http://localhost:5000/api/v1/orders'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return res;
    });
    final body = _processResponse(response);
    if (body['data'] is List) {
      return List<Map<String, dynamic>>.from(body['data']);
    } else {
      return [];
    }
  }

  Future<void> placeOrder(String token, String productId, int quantity) async {
    await safeApiCall(() async {
      final res = await http.post(
        Uri.parse('http://localhost:5000/api/v1/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'productId': productId, 'quantity': quantity}),
      );
      _processResponse(res);
      return res;
    });
  }

  Future<Map<String, dynamic>> getOrderDetail(String token, String orderId) async {
    final response = await safeApiCall(() async {
      final res = await http.get(
        Uri.parse('http://localhost:5000/api/v1/orders/$orderId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return res;
    });
    final body = _processResponse(response);
    return body['data'] ?? {};
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    final Map<String, dynamic> body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      // Token expired or invalid, clear session and redirect to login
      _handleSessionExpired();
      throw Exception('Session expired. Please log in again.');
    } else {
      throw Exception(body['message'] ?? 'Unknown error');
    }
  }

  void _handleSessionExpired() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_id');
    // Optionally, use a global navigator key to redirect to login
    // navigatorKey.currentState?.pushNamedAndRemoveUntil('/login', (route) => false);
  }

  // Wrap all API calls in try/catch for network errors
  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on SocketException {
      throw Exception('No internet connection.');
    } catch (e) {
      rethrow;
    }
  }
} 