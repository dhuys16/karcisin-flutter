import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/event_model.dart';
import '../shared/config.dart';

class EventRepository {
  Future<List<EventModel>> getEvents() async {
    final response = await http.get(Uri.parse("${Config.baseUrl}/events"));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => EventModel.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data dari server");
    }
  }
}