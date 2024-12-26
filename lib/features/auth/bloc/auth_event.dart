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

  const SignUpRequested(this.email, this.password, this.username);

  @override
  List<Object> get props => [email, password, username];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class RefreshTokenRequested extends AuthEvent {

  final String refreshToken;

  const RefreshTokenRequested(this.refreshToken);

  @override
  List<Object> get props => [refreshToken];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
  @override
  List<Object> get props => [];
}