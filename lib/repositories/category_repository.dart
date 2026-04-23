import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/response/category_response.dart';
import '../shared/config.dart';

class CategoryRepository {
  // Fungsi untuk mengambil daftar kategori
  Future<List<CategoryResponse>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((json) => CategoryResponse.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data kategori");
    }
  }

  // Fungsi untuk menambah kategori baru
  Future<void> addCategory(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      body: {'name': name},
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Gagal menambah kategori");
    }
  }

  Future<void> deleteCategory(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/categories/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Gagal menghapus kategori");
    }
  }
}