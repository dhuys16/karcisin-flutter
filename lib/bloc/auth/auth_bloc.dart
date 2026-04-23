import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../repositories/auth_repository.dart';

/// {@template auth_bloc}
/// BLoC yang mengelola seluruh state autentikasi aplikasi.
///
/// Menerima [AuthEvent] dan menghasilkan [AuthState] sesuai
/// hasil operasi dari [AuthRepository].
///
/// ### Event yang didukung:
/// - [LoginSubmitted]    → proses login
/// - [RegisterSubmitted] → proses register
/// - [LogoutRequested]   → proses logout (hapus sesi lokal)
///
/// ### State yang mungkin dihasilkan:
/// - [AuthLoading]       → sedang memproses request
/// - [Authenticated]     → login berhasil, menyimpan role & token
/// - [Unauthenticated]   → belum login / setelah logout / setelah register
/// - [AuthActionSuccess] → operasi berhasil dengan pesan info (misal: register sukses)
/// - [AuthError]         → terjadi kegagalan, menyimpan pesan error
/// {@endtemplate}
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Repository yang digunakan untuk semua operasi autentikasi.
  final AuthRepository _authRepository;

  /// {@macro auth_bloc}
  ///
  /// [authRepository] bersifat opsional; jika tidak diberikan, akan
  /// membuat instance [AuthRepository] baru secara otomatis.
  AuthBloc({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(),
      super(AuthInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<RegisterSubmitted>(_onRegisterSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<AppStarted>(_onAppStarted);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated(role: 'user', token: token));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // ---------------------------------------------------------------------------
  // Handler: Login
  // ---------------------------------------------------------------------------

  /// Menangani event [LoginSubmitted].
  ///
  /// Alur:
  /// 1. Emit [AuthLoading]
  /// 2. Panggil [AuthRepository.login]
  /// 3. Jika berhasil → simpan token ke SharedPreferences → emit [Authenticated]
  /// 4. Jika gagal     → emit [AuthError] dengan pesan dari [AuthException]
  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.login(
        email: event.email,
        password: event.password,
      );

      // Simpan token secara persisten agar sesi tetap aktif setelah restart
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result.token);
      await prefs.setInt('user_id', result.user.id);

      emit(Authenticated(role: result.user.role, token: result.token));
    } on AuthException catch (e) {
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan tidak terduga.'));
    }
  }

  // ---------------------------------------------------------------------------
  // Handler: Register
  // ---------------------------------------------------------------------------

  /// Menangani event [RegisterSubmitted].
  ///
  /// Alur:
  /// 1. Emit [AuthLoading]
  /// 2. Panggil [AuthRepository.register] dengan data dari event
  /// 3. Jika berhasil → emit [AuthActionSuccess] (dengan pesan sukses)
  ///                  → emit [Unauthenticated] agar UI kembali ke halaman login
  /// 4. Jika gagal    → emit [AuthError] dengan pesan dari [AuthException]
  ///
  /// Catatan: setelah register berhasil kamu **tidak** langsung login otomatis.
  /// Pengguna diarahkan kembali ke halaman login untuk masuk secara manual.
  /// Jika ingin auto-login, simpan token hasil register ke SharedPreferences
  /// dan emit [Authenticated] langsung.
  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Delegasikan ke repository; validasi input dilakukan di dalam repository
      await _authRepository.register(
        name: event.name,
        email: event.email,
        password: event.password,
        phone: event.phone,
        role: event.role,
      );

      // Beri tahu UI bahwa registrasi berhasil
      emit(AuthActionSuccess('Akun berhasil dibuat! Silakan login.'));

      // Kembalikan ke state unauthenticated agar layar login ditampilkan
      emit(Unauthenticated());
    } on AuthException catch (e) {
      // Pesan error sudah user-friendly dari AuthRepository
      emit(AuthError(e.message));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan tidak terduga.'));
    }
  }

  // ---------------------------------------------------------------------------
  // Handler: Logout
  // ---------------------------------------------------------------------------

  /// Menangani event [LogoutRequested].
  ///
  /// Menghapus token dari SharedPreferences dan mengembalikan state
  /// ke [Unauthenticated].
  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    emit(Unauthenticated());
  }
}
