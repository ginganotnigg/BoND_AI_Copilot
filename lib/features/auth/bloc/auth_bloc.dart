
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/helpers/auth_helper.dart';
import '../models/tokens.dart';
import '../service/auth_api.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApi authApi = AuthApi();
  AuthBloc() : super(const Unauthenticated("")) {
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        Tokens tokens = await authApi.signIn(event.email, event.password);
        if (tokens.isSuccess == false) {
          emit(Unauthenticated(tokens.message));
        }
        else {
          emit(Authenticated(tokens.accessToken));
        }
      } catch (e) {
        emit(const Unauthenticated("Something wrong happen, please try again"));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        Tokens tokens = await authApi.signUp(event.email, event.password, event.username);
        emit(Unauthenticated(tokens.message));
      } catch (e) {
        emit(const Unauthenticated("Something wrong happen, please try again"));
      }
    });

    on<SignOutRequested>((event, emit) async {
      emit(Loading());
      try {
        await authApi.signOut();
        emit(const Unauthenticated("Signed Out"));
      } catch (e) {
        emit(const Unauthenticated("Signed Out"));
      }
    });
  }
}