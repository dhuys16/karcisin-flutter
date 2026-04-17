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
          body: {'email': event.email, 'password': event.password},
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final String token = data['token'];
          final String role = data['user']['role']; // Role dari DB temanmu

          // Simpan token ke HP
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          emit(Authenticated(role: role, token: token));
        } else {
          emit(AuthError("Email atau password salah"));
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