part of 'auth_bloc.dart';

abstract class AuthEvent {}

class AuthUserEvent extends AuthEvent {
  final String? login;
  final String? password;
  final String? url;
  final BuildContext? context;
  AuthUserEvent({
    this.login,
    this.password,
    this.context,
    this.url,
  });
} 

class LoadUserEvent extends AuthEvent {}

class LogoutUserEvent extends AuthEvent {}
