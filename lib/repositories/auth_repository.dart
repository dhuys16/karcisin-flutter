import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/response/user_response.dart';
import '../shared/config.dart';

class AuthException implements Exception {
  final String message;
  final int? statusCode;
  const AuthException(this.message, {this.statusCode});

  @override
  String toString() => 'AuthException($statusCode): $message';
}

class RegisterResult {
  final UserResponse user;
  final String token;

  const RegisterResult({required this.user, required this.token});
}

class AuthRepository {

  final http.Client _client;

  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {

    _validateRegisterInput(
      name: name,
      email: email,
      password: password,
      phone: phone,
    );

    try {
      final response = await _client.post(
        Uri.parse(
          '${Config.baseUrl}/register',
        ),
        headers: _defaultHeaders,
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'password': password,
          'phone': phone.trim(),
        }),
      );

      final Map<String, dynamic> responseBody = _decodeBody(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {

        final data = responseBody['data'] as Map<String, dynamic>;
        final token = data['token'] as String;
        final user = UserResponse.fromJson(data['user'] as Map<String, dynamic>);

        return RegisterResult(user: user, token: token);
      } else if (response.statusCode == 422) {

        final errors = responseBody['errors'];
        String errorMessage = 'Data tidak valid.';

        if (errors is Map && errors.isNotEmpty) {

          final firstField = errors.values.first;
          if (firstField is List && firstField.isNotEmpty) {
            errorMessage = firstField.first.toString();
          }
        } else if (responseBody['message'] != null) {
          errorMessage = responseBody['message'].toString();
        }

        throw AuthException(errorMessage, statusCode: 422);
      } else {

        final message =
            responseBody['message']?.toString() ??
            'Terjadi kesalahan pada server.';
        throw AuthException(message, statusCode: response.statusCode);
      }
    } on AuthException {

      rethrow;
    } catch (e) {

      throw AuthException(
        'Koneksi ke server bermasalah. Periksa internet kamu.',
      );
    }
  }

  Future<RegisterResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(
          '${Config.baseUrl}/login',
        ),
        headers: _defaultHeaders,
        body: jsonEncode({
          'email': email.trim().toLowerCase(),
          'password': password,
        }),
      );

      final Map<String, dynamic> responseBody = _decodeBody(response.body);

      if (response.statusCode == 200) {
        final data = responseBody['data'] as Map<String, dynamic>;
        final token = data['token'] as String;
        final user = UserResponse.fromJson(data['user'] as Map<String, dynamic>);
        return RegisterResult(user: user, token: token);
      } else if (response.statusCode == 401) {
        throw const AuthException(
          'Email atau password salah.',
          statusCode: 401,
        );
      } else {
        final message = responseBody['message']?.toString() ?? 'Gagal login.';
        throw AuthException(message, statusCode: response.statusCode);
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(
        'Koneksi ke server bermasalah. Periksa internet kamu.',
      );
    }
  }

  void _validateRegisterInput({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) {
    if (name.trim().isEmpty) {
      throw const AuthException('Nama lengkap tidak boleh kosong.');
    }
    if (email.trim().isEmpty) {
      throw const AuthException('Email tidak boleh kosong.');
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email.trim())) {
      throw const AuthException('Format email tidak valid.');
    }
    if (phone.trim().isEmpty) {
      throw const AuthException('Nomor HP tidak boleh kosong.');
    }
    if (password.isEmpty) {
      throw const AuthException('Password tidak boleh kosong.');
    }
    if (password.length < 8) {
      throw const AuthException('Password minimal 8 karakter.');
    }
  }

  Map<String, dynamic> _decodeBody(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      throw const AuthException('Response dari server tidak dapat dibaca.');
    }
  }
}
