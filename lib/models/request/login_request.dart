class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  // Mengubah inputan Flutter menjadi format JSON yang dimengerti Laravel
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}