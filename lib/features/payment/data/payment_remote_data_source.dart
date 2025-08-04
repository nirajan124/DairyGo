import 'package:dio/dio.dart';
import '../../../../core/network/api_endpoints.dart';
import 'payment_model.dart';

class PaymentRemoteDataSource {
  // Use a different Dio instance for khalti routes since they're not under /api/v1
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://10.0.2.2:3001'));

  Future<PaymentResponse> initiateSimplePayment(PaymentRequest request) async {
    try {
      print('Making payment request to: /api/simple-payment/payment');
      print('Request data: ${request.toJson()}');
      
      final response = await _dio.post(
        '/api/simple-payment/payment',
        data: request.toJson(),
      );

      print('Payment response status: ${response.statusCode}');
      print('Payment response data: ${response.data}');

      if (response.statusCode == 200) {
        return PaymentResponse.fromJson(response.data);
      } else {
        throw Exception('Payment initiation failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('Payment error: ${e.message}');
      print('Payment error type: ${e.type}');
      print('Payment error response: ${e.response?.data}');
      throw Exception('Payment initiation failed: ${e.message}');
    } catch (e) {
      print('Unexpected payment error: $e');
      throw Exception('Payment initiation failed: $e');
    }
  }

  Future<PaymentResponse> verifyPayment(String transactionId) async {
    try {
      final response = await _dio.get(
        '/api/khalti/verify/$transactionId',
      );

      if (response.statusCode == 200) {
        return PaymentResponse.fromJson(response.data);
      } else {
        throw Exception('Payment verification failed: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('Payment verification error: ${e.message}');
      throw Exception('Payment verification failed: ${e.message}');
    } catch (e) {
      print('Unexpected payment verification error: $e');
      throw Exception('Payment verification failed: $e');
    }
  }
} 