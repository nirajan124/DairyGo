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

  // Login method
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Register method
  Future<Response> register({
    required String fname,
    required String lname,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'fname': fname,
        'lname': lname,
        'phone': phone,
        'email': email,
        'password': password,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  Future<Map<String, dynamic>> getProfile(String userId, String token) async {
    try {
      final response = await _dio.get('/customers/getCustomer', 
        queryParameters: {'userId': userId},
        options: Options(headers: {'Authorization': 'Bearer $token'})
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  // Get products
  Future<Response> getProducts() async {
    try {
      final response = await _dio.get(ApiEndpoints.products);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get product by ID
  Future<Response> getProductById(String productId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.productById}$productId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get wishlist
  Future<Response> getWishlist() async {
    try {
      final response = await _dio.get(ApiEndpoints.wishlist);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Add to wishlist
  Future<Response> addToWishlist(String productId) async {
    try {
      final response = await _dio.post(ApiEndpoints.addToWishlist, data: {
        'productId': productId,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Remove from wishlist
  Future<Response> removeFromWishlist(String productId) async {
    try {
      final response = await _dio.delete('${ApiEndpoints.removeFromWishlist}$productId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get orders
  Future<Response> getOrders() async {
    try {
      final response = await _dio.get(ApiEndpoints.getBookings);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile
  Future<Response> updateProfile({
    required String userId,
    required String token,
    required String fname,
    required String lname,
    required String phone,
    required String email,
    String? imagePath,
  }) async {
    try {
      final response = await _dio.put('/customers/updateCustomer', 
        data: {
          'userId': userId,
          'fname': fname,
          'lname': lname,
          'phone': phone,
          'email': email,
          'imagePath': imagePath,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'})
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Get product detail
  Future<Response> getProductDetail(String productId) async {
    try {
      final response = await _dio.get('${ApiEndpoints.productById}$productId');
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Place order
  Future<Response> placeOrder({
    required String productId,
    required int quantity,
    required String userId,
  }) async {
    try {
      final response = await _dio.post(ApiEndpoints.createBooking, data: {
        'productId': productId,
        'quantity': quantity,
        'userId': userId,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Safe API call wrapper
  Future<T> safeApiCall<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } catch (e) {
      rethrow;
    }
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
    } catch (e) {
      rethrow;
    }
  }
} 