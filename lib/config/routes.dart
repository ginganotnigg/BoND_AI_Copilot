import 'package:bond/features/auth/ui/auth_screen.dart';
import 'package:bond/features/auth/ui/pricing_screen.dart';
import 'package:bond/features/chat/ui/assistant_screen.dart';
import 'package:bond/features/chat/ui/chat_screen.dart';
import 'package:bond/features/knowledge_base/ui/create_bot.dart';
import 'package:go_router/go_router.dart';
import 'package:bond/features/auth/ui/home.dart';

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
      path: '/create-bot',
      builder: (context, state) => const CreateBotScreen(),
    ),
    GoRoute(
      path: '/ai-chat',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        final selectedModel = extra['model'] as String;
        final conversationId = extra['conversationId'] as String?;
        return ChatScreen(
          initialSelectedModel: selectedModel,
          conversationId: conversationId,
        );
      },
    ),
  ],
);
