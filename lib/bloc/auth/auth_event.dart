abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;
  LoginSubmitted({required this.email, required this.password});
}

class LogoutRequested extends AuthEvent {}

class AppStarted extends AuthEvent {}

class RegisterSubmitted extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String role;

  RegisterSubmitted({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.role,
  });
}
