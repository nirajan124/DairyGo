import 'dart:convert';
import 'package:http/http.dart' as http;

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
    required String email,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/updateCustomer/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'fname': fname,
        'email': email,
      }),
    );
    _processResponse(response);
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    final Map<String, dynamic> body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception(body['message'] ?? 'Unknown error');
    }
  }
} 