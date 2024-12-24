import 'package:bond/features/chat/bloc/chat_bloc/chat_bloc.dart';
import 'package:bond/features/prompt/bloc/prompt_bloc.dart';
import 'package:bond/config/routes.dart';
import 'package:bond/features/prompt/service/prompt_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/bloc/auth_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChatBloc()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => PromptBloc(PromptApi())),
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
