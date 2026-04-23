import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/response/event_response.dart';
import '../shared/config.dart';

class EventRepository {
  Future<List<EventResponse>> getEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse("${Config.baseUrl}/events"),
      headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      // Akan otomatis diproses dengan aman menggunakan logika barumu!
      return data.map((json) => EventResponse.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data dari server");
    }
  }
}
