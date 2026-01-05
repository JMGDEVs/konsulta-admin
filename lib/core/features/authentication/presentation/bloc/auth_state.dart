part of 'auth_bloc.dart';

abstract class AuthState {}

final class AuthInitialState extends AuthState {}

final class ButtonLoading extends AuthState {}

final class SuccessLogin extends AuthState {}

final class LoginFailed extends AuthState {
  final String message;
  LoginFailed(this.message);
}
