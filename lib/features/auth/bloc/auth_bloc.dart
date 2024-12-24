
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/auth_api.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthApi authApi = AuthApi();
  AuthBloc() : super(Unauthenticated("")) {
    on<SignInRequested>((event, emit) async {
      emit(Loading());
      try {
        String token = await authApi.signIn(event.email, event.password);
        if (token == 'failed') emit(Unauthenticated("Login Information is not correct"));
        else emit(Authenticated(token));
      } catch (e) {
        print(e);
        emit(Unauthenticated("Something wrong happen, please try again"));
      }
    });

    on<SignUpRequested>((event, emit) async {
      emit(Loading());
      try {
        String message = await authApi.signUp(event.email, event.password, event.username);
        emit(Unauthenticated(message));
      } catch (e) {
        print(e);
        emit(Unauthenticated("Something wrong happen, please try again"));
      }
    });
  }
}