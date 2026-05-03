import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/request/booking_request.dart';
import '../models/response/booking_response.dart';
import '../shared/config.dart';

class BookingRepository {
  final String baseUrl = Config.baseUrl; // Mengacu pada baseUrl di config.dart

  // Mendapatkan Snap Token untuk simulasi Midtrans
  Future<String?> getSnapToken(BookingRequest requestData, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings/checkout'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestData.toJson()),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['snap_token'];
    }
    return null;
  }

  // Mengambil daftar riwayat booking user
  Future<List<Booking>> getMyBookings(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings'), // Sesuai route di api.php[cite: 2]
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((json) => Booking.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }
}