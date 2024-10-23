import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Go back to the previous route
            GoRouter.of(context).go('/');
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the register screen
            GoRouter.of(context).go('/register');
          },
          child: const Text('Register'),
        ),
      ),
    );
  }
}
