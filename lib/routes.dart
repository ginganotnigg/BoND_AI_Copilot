import 'package:bond/ui/auth_screen.dart';
import 'package:bond/ui/pricing_screen.dart';
import 'package:bond/ui/assistant_screen.dart';
import 'package:go_router/go_router.dart';
import 'main.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/pricing-plan',
      builder: (context, state) => const PricingScreen(),
    ),
    GoRoute(
      path: '/assistant',
      builder: (context, state) => const AssistantScreen(),
    ),
  ],
);
