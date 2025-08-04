import 'package:dio/dio.dart';
import 'api_endpoints.dart';

class ConnectionTest {
  static Future<bool> testBackendConnection() async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      // Test a simple GET request to check if server is reachable
      await dio.get('/customers');
      // Backend connection test successful
      return true;
    } catch (e) {
      // Backend connection test failed: $e
      return false;
    }
  }
} 