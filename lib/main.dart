import 'package:bond/features/chat/bloc/chat_bloc/chat_bloc.dart';
import 'package:bond/features/prompt/bloc/prompt_bloc.dart';
import 'package:bond/config/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/bot/bloc/bot_bloc.dart';
import 'features/bot_knowledge/bloc/bot_knowledge_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChatBloc()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => BotBloc()),
        BlocProvider(create: (_) => BotKnowledgeBloc()),
        BlocProvider(create: (_) => ImportKnowledgeBloc()),
        BlocProvider(create: (_) => PromptBloc()),
      ],
      child: const BondAI(),
    ),
  );
}

class BondAI extends StatelessWidget {
  const BondAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bond AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'FiraSans'),
      routerConfig: router,
    );
  }
}
