<<<<<<< HEAD
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
=======
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_endpoints.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add logging interceptor for debugging
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));

    // Add auth interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Add auth token if available
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Handle common errors
        if (error.response?.statusCode == 401) {
          // Token expired or invalid
          _handleAuthError();
        }
        handler.next(error);
      },
    ));
  }

  void _handleAuthError() async {
    // Clear stored token and redirect to login
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    // You can add navigation logic here if needed
  }

  // GET request
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST request
  Future<Response> post(String path, {dynamic data}) async {
    try {
      final response = await _dio.post(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT request
  Future<Response> put(String path, {dynamic data}) async {
    try {
      final response = await _dio.put(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE request
  Future<Response> delete(String path) async {
    try {
      final response = await _dio.delete(path);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // POST request with form data (for file uploads)
  Future<Response> postFormData(String path, FormData formData) async {
    try {
      final response = await _dio.post(path, data: formData);
      return response;
>>>>>>> master
    } catch (e) {
      rethrow;
    }
  }
} 