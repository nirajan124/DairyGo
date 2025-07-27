import 'dart:convert';
import 'package:http/http.dart' as http;
import 'booking_model.dart';

class BookingRemoteDataSource {
  final String baseUrl;
  final http.Client client;

  BookingRemoteDataSource({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Future<List<BookingModel>> fetchBookingsForUser(String userId) async {
    final response = await client.get(Uri.parse('$baseUrl/bookings/user/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => BookingModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }
} 