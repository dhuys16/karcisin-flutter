import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/response/user_response.dart';
import '../shared/config.dart';

class UserRepository {
  Future<List<UserResponse>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => UserResponse.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data pengguna");
    }
  }
}
