import 'dart:convert';

import 'package:karcisin_app/shared/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:karcisin_app/models/user_model.dart';

class ProfileRepository {
  Future<UserModel> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');
    
    if (token == null) throw Exception('Token tidak ditemukan');

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    print("url: ${Config.baseUrl}/users/$userId");

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      // Ambil isi dari key 'data'
      final dynamic rawData = responseData['data'];

      if (rawData == null) {
        throw Exception('Data user kosong dari server');
      }

      // Jika server kirim List (seperti di log kamu), ambil index pertama
      if (rawData is List) {
        if (rawData.isNotEmpty) {
          return UserModel.fromJson(rawData[0]);
        }
        throw Exception('Daftar user kosong');
      }

      // Jika server kirim objek tunggal, langsung parsing
      return UserModel.fromJson(rawData);
    } else {
      // Tambahkan detail status code biar debug di Fedora-mu lebih enak
      throw Exception('Gagal ambil data user (Status: ${response.statusCode})');
    }
  }
}