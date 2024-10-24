import 'package:bond/ui/auth_screen.dart';
import 'package:bond/ui/pricing_screen.dart';
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
      builder: (context, state) => const AuthScreen(),
    ),
    // Other Routes
    GoRoute(
      path: '/register',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/pricing-plan',
      builder: (context, state) => const PricingScreen(),
    )
  ],
);
