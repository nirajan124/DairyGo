import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';

class ProductRemoteDataSource {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));

  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await _dio.get(ApiEndpoints.products);
    print('Product API response: ${response.data}');
    final data = response.data;
    print('data.runtimeType: ${data.runtimeType}');
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    } else if (data is Map && data['data'] is List) {
      return List<Map<String, dynamic>>.from(data['data']);
    } else if (data is Map) {
      return List<Map<String, dynamic>>.from(data.values);
    } else {
      throw Exception('Unexpected data format: ${data.runtimeType}');
    }
  }
} 