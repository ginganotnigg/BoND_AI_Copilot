import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class Loading extends AuthState {}

class Authenticated extends AuthState {
  final String token;

  const Authenticated(this.token);

  @override
  List<Object?> get props => [token];
}

class Unauthenticated extends AuthState {
  final String message;

  const Unauthenticated(this.message);

  @override
  List<Object?> get props => [message];
}

class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);
  @override
  List<Object?> get props => [error];
}