import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class BackendTest {
  static Future<Map<String, dynamic>> testBackendConnection() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      print('Testing backend connection to: ${ApiEndpoints.baseUrl}');
      
      // Test if server is reachable
      final response = await dio.get('/customers');
      
      return {
        'success': true,
        'statusCode': response.statusCode,
        'message': 'Backend is accessible',
        'data': response.data,
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'errorType': e.type.toString(),
        'message': 'Backend connection failed: ${e.message}',
        'details': e.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unexpected error: ${e.toString()}',
      };
    }
  }

  static Future<Map<String, dynamic>> testRegistrationEndpoint() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      print('Testing registration endpoint: ${ApiEndpoints.register}');
      
      // Test with minimal data
      final testData = {
        'fname': 'Test',
        'lname': 'User',
        'email': 'test@example.com',
        'phone': '1234567890',
        'password': 'testpassword',
        'role': 'customer',
      };

      final response = await dio.post('/customers/register', data: testData);
      
      return {
        'success': true,
        'statusCode': response.statusCode,
        'message': 'Registration endpoint is working',
        'data': response.data,
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'errorType': e.type.toString(),
        'message': 'Registration endpoint failed: ${e.message}',
        'details': e.toString(),
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Unexpected error: ${e.toString()}',
      };
    }
  }
} 