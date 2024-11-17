import 'package:bond/global.dart';
import 'package:bond/ui/auth/auth_input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    bool isLogin =
        GoRouter.of(context).routeInformationProvider.value.uri.toString() ==
            '/login';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                  'lib/assets/images/icon-48.png',
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
            if (!isLogin) ...[
              TextField(
                decoration: usernameFieldDecoration,
              ),
              const SizedBox(height: 10),
            ],
            TextField(
              decoration: emailFieldDecoration,
            ),
            const SizedBox(height: 10),
            TextField(
              obscureText: true,
              decoration: passwordFieldDecoration,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: filled,
                child: Text(
                  isLogin ? 'Login' : 'Register',
                  style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
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
      ),
    );
  }
}
