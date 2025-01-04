import 'package:bond/ui/ai-email/ai_email_screen.dart';
import 'package:bond/ui/auth/auth_screen.dart';
import 'package:bond/ui/auth/pricing_screen.dart';
import 'package:bond/ui/chat/assistant_screen.dart';
import 'package:bond/ui/chat/chat_screen.dart';
import 'package:bond/ui/chat/create_bot.dart';
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
          selectedModel: selectedModel,
          conversationId: conversationId,
        );
      },
    ),
    GoRoute(
      path: '/ai-email',
      builder: (context, state) => const EmailReplyScreen(),
    ),
  ],
);
