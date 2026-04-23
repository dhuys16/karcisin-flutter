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

// ---------------------------------------------------------------------------
// Repository
// ---------------------------------------------------------------------------

/// {@template auth_repository}
/// Repository yang bertanggung jawab atas semua operasi autentikasi:
/// login, register, dan logout.
///
/// Semua komunikasi dengan API dilakukan di sini, sehingga BLoC tetap
/// bersih dari detail HTTP.
///
/// Contoh penggunaan di BLoC:
/// ```dart
/// final _repo = AuthRepository();
///
/// // Register
/// final result = await _repo.register(
///   name: 'Budi',
///   email: 'budi@test.com',
///   password: 'secret123',
///   role: 'user',
/// );
/// ```
/// {@endtemplate}
class AuthRepository {
  /// HTTP client yang digunakan untuk semua request.
  ///
  /// Bisa di-inject dari luar (berguna untuk unit testing dengan mock client).
  final http.Client _client;

  /// Header standar yang dikirim ke setiap endpoint API.
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// {@macro auth_repository}
  ///
  /// [client] bersifat opsional; jika tidak diberikan, akan menggunakan
  /// `http.Client()` bawaan.
  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  // -------------------------------------------------------------------------
  // Register
  // -------------------------------------------------------------------------

  /// Mendaftarkan pengguna baru ke server.
  ///
  /// Mengirim HTTP POST ke `{baseUrl}/register` dengan payload:
  /// ```json
  /// {
  ///   "name": "...",
  ///   "email": "...",
  ///   "phone": "...",
  ///   "password": "...",
  ///   "role": "user" | "owner"
  /// }
  /// ```
  ///
  /// ### Response sukses yang diharapkan (HTTP 200 / 201):
  /// ```json
  /// {
  ///   "data": {
  ///     "token": "...",
  ///     "user": { "id": 1, "name": "...", "email": "...", "role": "..." }
  ///   }
  /// }
  /// ```
  ///
  /// ### Throws
  /// - [AuthException] jika validasi server gagal (422), email sudah dipakai
  ///   (biasanya 422), atau status error lainnya.
  /// - [AuthException] jika terjadi error jaringan / koneksi.
  ///
  /// ### Returns
  /// [RegisterResult] yang berisi [UserModel] dan token string jika berhasil.
  Future<RegisterResult> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
  }) async {
    // Validasi sisi klien sebelum mengirim request
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
        ), // ← Ganti endpoint sesuai API kamu
        headers: _defaultHeaders,
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'password': password,
          'phone': phone.trim(),
          'role': role,
        }),
      );

      // Decode body JSON
      final Map<String, dynamic> responseBody = _decodeBody(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ── Sukses ──
        // Sesuaikan key 'data', 'token', 'user' dengan response API kamu
        final data = responseBody['data'] as Map<String, dynamic>;
        final token = data['token'] as String;
        final user = UserResponse.fromJson(data['user'] as Map<String, dynamic>);

        return RegisterResult(user: user, token: token);
      } else if (response.statusCode == 422) {
        // ── Validation error dari Laravel ──
        final errors = responseBody['errors'];
        String errorMessage = 'Data tidak valid.';

        if (errors is Map && errors.isNotEmpty) {
          // Ambil pesan error pertama dari setiap field
          final firstField = errors.values.first;
          if (firstField is List && firstField.isNotEmpty) {
            errorMessage = firstField.first.toString();
          }
        } else if (responseBody['message'] != null) {
          errorMessage = responseBody['message'].toString();
        }

        throw AuthException(errorMessage, statusCode: 422);
      } else {
        // ── Error tidak terduga dari server ──
        final message =
            responseBody['message']?.toString() ??
            'Terjadi kesalahan pada server.';
        throw AuthException(message, statusCode: response.statusCode);
      }
    } on AuthException {
      // Re-throw AuthException agar BLoC bisa tangkap langsung
      rethrow;
    } catch (e) {
      // Network error, timeout, dll.
      throw AuthException(
        'Koneksi ke server bermasalah. Periksa internet kamu.',
      );
    }
  }

  // -------------------------------------------------------------------------
  // Login
  // -------------------------------------------------------------------------

  /// Login pengguna yang sudah terdaftar.
  ///
  /// Mengirim HTTP POST ke `{baseUrl}/login` dengan payload:
  /// ```json
  /// { "email": "...", "password": "..." }
  /// ```
  ///
  /// ### Throws
  /// - [AuthException] dengan status 401 jika email/password salah.
  /// - [AuthException] untuk error lainnya.
  ///
  /// ### Returns
  /// [RegisterResult] berisi [UserModel] dan token jika berhasil.
  Future<RegisterResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(
          '${Config.baseUrl}/login',
        ), // ← Ganti endpoint sesuai API kamu
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

  // -------------------------------------------------------------------------
  // Private Helpers
  // -------------------------------------------------------------------------

  /// Memvalidasi input register **sebelum** dikirim ke server.
  ///
  /// Melempar [AuthException] jika ada field yang tidak valid.
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
    // Regex sederhana untuk format email
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

  /// Men-decode body JSON response menjadi [Map].
  ///
  /// Melempar [AuthException] jika body tidak dapat di-parse.
  Map<String, dynamic> _decodeBody(String body) {
    try {
      return jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      throw const AuthException('Response dari server tidak dapat dibaca.');
    }
  }
}
