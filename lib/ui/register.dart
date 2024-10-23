import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
            // Navigate to the login screen
            GoRouter.of(context).go('/login');
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
