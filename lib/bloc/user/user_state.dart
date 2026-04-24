import '../../models/response/user_response.dart';

abstract class UserState {}

class UserInitial extends UserState {}
class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<UserResponse> users;
  UserLoaded(this.users);
}

class UserError extends UserState {
  final String message;
  UserError(this.message);
}
