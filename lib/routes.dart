import 'package:bond/ui/register.dart';
import 'package:bond/ui/login.dart';
import 'package:go_router/go_router.dart';

// Import your screens
import 'main.dart'; // Import HomeScreen from main.dart

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    // Main Route
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    // Login Route
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // Other Routes
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    )
  ],
);
