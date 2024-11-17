import 'package:bond/ui/auth/auth_screen.dart';
import 'package:bond/ui/auth/pricing_screen.dart';
import 'package:bond/ui/chat/assistant_screen.dart';
import 'package:bond/ui/chat/chat_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:bond/ui/home/home.dart';

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
    GoRoute(
      path: '/ai-chat',
      builder: (context, state) {
        final selectedModel = state.extra as String;
        return ChatScreen(selectedModel: selectedModel);
      },
    ),
  ],
);
