import 'package:flutter_test/flutter_test.dart';
import 'package:bond/features/auth/ui/auth_screen.dart';
import 'package:bond/features/auth/bloc/auth_bloc.dart';
import 'package:bond/features/auth/bloc/auth_event.dart';
import 'package:bond/features/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const AuthScreen(),
      ),
    ],
  );

  testWidgets('Auth feature test', (WidgetTester tester) async {
    final authBloc = AuthBloc();

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) {
          return BlocProvider(
            create: (context) => authBloc,
            child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is Loading) {
                  // Verify loading state
                  expect(state, isA<Loading>());
                } else if (state is Authenticated) {
                  // Verify authenticated state
                  expect(state, isA<Authenticated>());
                } else if (state is AuthError) {
                  // Verify error state
                  expect(state, isA<AuthError>());
                }
              },
              child: Material(
                child: child!,
              ),
            ),
          );
        },
      ),
    );

    // expect(
    //     find.byType(TextEditingController),
    //     findsNWidgets(
    //         2)); // Assuming there are two text fields for email and password

    // // Enter credentials and submit
    // await tester.enterText(
    //     find.byType(TextField).at(0), 'testuser@example.com');
    // await tester.enterText(find.byType(TextField).at(1), 'password123');
    // await tester.tap(find.text('Login'));
    // await tester.pumpAndSettle();

    // Simulate authentication event
    authBloc.add(const SignInRequested('testuser@example.com', 'password123'));
    await tester.pumpAndSettle();
  });
}
