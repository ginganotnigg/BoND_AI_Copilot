import 'package:bond/shared/styles/styles.dart';
import 'package:bond/features/auth/ui/auth_input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Still import if using Bloc for events

import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/auth_event.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _retypeController = TextEditingController();

  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _retypeError;

  bool isLogin = true;

  @override
  void initState() {
    super.initState();
  }

  bool _isStrongPassword(String password) {
    final regex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_.~])[A-Za-z\d!@#$%^&*()_.~]{8,}$');
    return regex.hasMatch(password);
  }

  void _validateInputs() {
    setState(() {
      _usernameError = null;
      _emailError = null;
      _passwordError = null;
      _retypeError = null;

      bool hasError = false;

      //Validate username is not empty
      if (_usernameController.text.isEmpty) {
        _usernameError = 'Username cannot be empty!';
        hasError = true;
      }

      // Validate email format
      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(_emailController.text)) {
        _emailError = 'Please enter a valid email address!';
        hasError = true;
      }

      // Validate password strength
      if (!_isStrongPassword(_passwordController.text)) {
        _passwordError = 'Password must be at least 8 characters long, '
            'and include uppercase, lowercase, number, and special character!';
        hasError = true;
      }

      //check mismatch
      if (_passwordController.text != _retypeController.text && !isLogin) {
        _retypeError = 'Password mismatch!';
        hasError = true;
      }

      // Clear text fields if there are errors
      if (hasError) {
        if (_usernameError != null) {
          _usernameController.clear();
        }
        if (_emailError != null) {
          _emailController.clear();
        }
        if (_passwordError != null || _retypeError != null) {
          _passwordController.clear();
          _retypeController.clear();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isLogin =
        GoRouter.of(context).routeInformationProvider.value.uri.toString() ==
            '/login';
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    iconSize: 35.0,
                    onPressed: () {
                      context.go('/');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'lib/assets/images/logo/icon-48.png',
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Bond',
                    style: TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.login),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color.fromARGB(255, 245, 244, 250),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              //USER NAME----------
              if (!isLogin) ...[
                _textFieldWithErrorShow(
                    controller: _usernameController,
                    decoration: usernameFieldDecoration,
                    errorText: _usernameError,
                    obscure: false),
                const SizedBox(height: 16),
              ],
              //EMAIL-------
              _textFieldWithErrorShow(
                  controller: _emailController,
                  decoration: emailFieldDecoration,
                  errorText: _emailError,
                  obscure: false),
              const SizedBox(height: 16),
              //PASSWORD-------------
              _textFieldWithErrorShow(
                  controller: _passwordController,
                  decoration: passwordFieldDecoration,
                  errorText: _passwordError,
                  obscure: true),
              const SizedBox(height: 16),
              //PASSWORD RETYPE-------------
              if (!isLogin) ...[
                _textFieldWithErrorShow(
                    controller: _retypeController,
                    decoration: retypeFieldDecoration,
                    errorText: _retypeError,
                    obscure: true),
                const SizedBox(height: 16),
              ],
              BlocConsumer<AuthBloc, AuthState>(listener: ((context, state) {
                if (state is Authenticated) {
                  context.go('/');
                } else if (state is Unauthenticated) {
                  if (state.status == true) {
                    context.go('/login');
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.message)));
                  }
                } else if (state is AuthError) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.error)));
                }
              }), builder: ((context, state) {
                if (state is Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is Unauthenticated) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _validateInputs();
                        if (isLogin) {
                          context.read<AuthBloc>().add(
                                SignInRequested(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                ),
                              );
                        } else if (_usernameError == null &&
                            _emailError == null &&
                            _passwordError == null &&
                            _retypeError == null) {
                          {
                            context.read<AuthBloc>().add(
                                  SignUpRequested(
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                    _usernameController.text.trim(),
                                  ),
                                );
                          }
                        }
                      },
                      style: filled,
                      child: Text(
                        isLogin ? 'Login' : 'Register',
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              })),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  isLogin ? context.go('/register') : context.go('/login');
                },
                child: Text(isLogin
                    ? "Don't have an account? Register"
                    : "Already have an account? Login"),
              ),
              const SizedBox(height: 20),
              const Text(
                'By continuing, you agree to our Privacy policy',
                style: TextStyle(fontSize: 12, fontFamily: 'Arya'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }

  Widget _textFieldWithErrorShow(
      {required TextEditingController controller,
      required InputDecoration decoration,
      String? errorText,
      required bool obscure}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: decoration,
          obscureText: obscure,
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
              maxLines: 2, // Limit to 2 lines
              overflow: TextOverflow.visible, // Allow it to wrap
            ),
          ),
      ],
    );
  }
}
