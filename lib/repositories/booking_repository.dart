import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/request/booking_request.dart';
import '../models/response/booking_response.dart';
import '../shared/config.dart';
import 'dart:core';
import 'dart:async';

class BookingRepository {
  final String baseUrl = Config.baseUrl; // Mengacu pada baseUrl di config.dart

  // Mendapatkan Snap Token untuk simulasi Midtrans
  Future<String?> getSnapToken(BookingRequest requestData, String token) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(requestData.toJson()),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body)['snap_token'];
    }else if(response.statusCode == 500){
      print("(500) : ${response.body}");
    }
    return null;
  }

  // Mengambil daftar riwayat booking user
  Future<List<BookingData>> getMyBookings(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings'), // Sesuai route di api.php[cite: 2]
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((json) => BookingData.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<BookingData> createBooking(String token, int packageId, int quantity) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bookings'), // Endpoint POST untuk store data
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'ticket_package_id': packageId, // Sesuai kolom di Fedora-mu
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body)['data'];
      return BookingData.fromJson(data); // Di sini ada snap_token-nya
    } else {
      throw Exception('Gagal membuat pesanan');
    }
  }
}