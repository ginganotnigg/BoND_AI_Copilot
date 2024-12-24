import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String username;

  SignUpRequested(this.email, this.password, this.username);

  @override
  List<Object> get props => [email, password, username];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOutRequested extends AuthEvent {}