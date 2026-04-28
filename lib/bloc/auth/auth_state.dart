abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String token;
  final String? name;
  Authenticated({required this.token, this.name});
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
