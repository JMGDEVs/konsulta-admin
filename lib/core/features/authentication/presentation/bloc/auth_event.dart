part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class OnLogin extends AuthEvent {
  final String username;
  final String password;
  const OnLogin(this.username, this.password);
}