part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

class LoginButtonPressed extends AuthenticationEvent {
  final String username;
  final String password;
  LoginButtonPressed({required this.username, required this.password});
}

class ObscurePasswordTapped extends AuthenticationEvent {}
