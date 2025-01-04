import 'package:bond/features/ai_email/ui/ai_email_screen.dart';
import 'package:bond/features/auth/ui/auth_screen.dart';
import 'package:bond/features/bot/ui/assistant_screen.dart';
import 'package:bond/features/chat/ui/chat_screen.dart';
import 'package:bond/features/knowledge_base/models/knowledge.dart';
import 'package:bond/features/knowledge_base/ui/create_bot.dart';
import 'package:bond/features/knowledge_unit/ui/confluence_screen.dart';
import 'package:bond/features/knowledge_unit/ui/drive_screen.dart';
import 'package:bond/features/knowledge_unit/ui/file_screen.dart';
import 'package:bond/features/knowledge_unit/ui/slack_screen.dart';
import 'package:bond/features/knowledge_unit/ui/unit_screen.dart';
import 'package:bond/features/knowledge_unit/ui/web_screen.dart';
import 'package:bond/features/subscription/ui/pricing_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:bond/features/auth/ui/home.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
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
      path: '/ai-email',
      builder: (context, state) => const EmailReplyScreen(),
    ),
    GoRoute(
      path: '/ai-chat',
      builder: (context, state) {
        final Map<String, dynamic> extra = state.extra as Map<String, dynamic>;
        final selectedModel = extra['model'] as String;
        final title = extra['title'] as String?;
        final conversationId = extra['conversationId'] as String?;
        return ChatScreen(
          title: title,
          initialSelectedModel: selectedModel,
          conversationId: conversationId,
        );
      },
    ),
    GoRoute(
      path: '/unit',
      builder: (context, state) {
        final knowledge = state.extra as Knowledge;
        return UnitScreen(knowledge: knowledge);
      },
    ),
    GoRoute(
      path: '/unit-confluence',
      builder: (context, state) {
        final knowledge = state.extra as Knowledge;
        return ConfluenceScreen(knowledge: knowledge);
      },
    ),
    GoRoute(
      path: '/unit-drive',
      builder: (context, state) {
        final knowledge = state.extra as Knowledge;
        return DriveScreen(knowledge: knowledge);
      },
    ),
    GoRoute(
      path: '/unit-file',
      builder: (context, state) {
        final knowledge = state.extra as Knowledge;
        return FileScreen(knowledge: knowledge);
      },
    ),
    GoRoute(
      path: '/unit-slack',
      builder: (context, state) {
        final knowledge = state.extra as Knowledge;
        return SlackScreen(knowledge: knowledge);
      },
    ),
    GoRoute(
      path: '/unit-web',
      builder: (context, state) {
        final knowledge = state.extra as Knowledge;
        return WebScreen(knowledge: knowledge);
      },
    ),
  ],
);
