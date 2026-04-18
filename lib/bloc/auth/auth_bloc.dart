import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../shared/config.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await http.post(
          Uri.parse("${Config.baseUrl}/login"),
          // Tambahkan header ini wajib!
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          // Encode body jadi JSON string
          body: jsonEncode({
            'email': event.email.trim(),
            'password': event.password.trim(),
          }),
        );

        if (response.statusCode == 200) {
          // print(response.body);
          final responseData = json.decode(response.body);

          // Perhatikan akses key 'data' dulu baru isinya
          final String token = responseData['data']['token'];
          final String role = responseData['data']['user']['role'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          emit(Authenticated(role: role, token: token));
        } else if  (response.statusCode == 401) {
          emit(AuthError("Email atau password salah"));
          print(response.body);
        } else {
          print("Status Code Nyasar: ${response.statusCode}");
          print("Isi Error Server: ${response.body}");
          emit(AuthError("Gagal login: ${response.statusCode}"));
        }
      } catch (e) {
        emit(AuthError("Koneksi ke server bermasalah (${e.toString()})"));
      }
    });

    on<LogoutRequested>((event, emit) {
      // Hapus token dan kembali ke Unauthenticated
      emit(Unauthenticated());
    });

    // Tambahkan di bawah logika on<LoginSubmitted>...

    on<RegisterSubmitted>((event, emit) async {
      emit(AuthLoading());
      try {
        // Simulasi request API ke endpoint /register Laravel
        // Nanti kamu bisa panggil http.post ke Config.baseUrl + "/register"
        await Future.delayed(const Duration(seconds: 2));

        // Jika sukses, kembalikan pesan berhasil
        emit(AuthActionSuccess("Akun berhasil dibuat! Silakan login."));
        emit(Unauthenticated()); // Kembalikan form ke posisi semula
      } catch (e) {
        emit(AuthError("Gagal mendaftar: ${e.toString()}"));
      }
    });
  }
}
