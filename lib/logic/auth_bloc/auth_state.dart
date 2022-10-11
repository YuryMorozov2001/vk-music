part of 'auth_bloc.dart';

class AuthState {
  final User? user;
  final Status status;
  final String? errorMessage;
  AuthState({this.user, this.status = Status.empty, this.errorMessage});

  AuthState copyWith({
    User? user,
    Status? status,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
