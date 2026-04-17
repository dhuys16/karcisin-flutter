abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String role; // 'admin', 'owner', atau 'user'
  final String token;
  Authenticated({required this.role, required this.token});
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthActionSuccess extends AuthState {
  final String message;
  AuthActionSuccess(this.message);
}