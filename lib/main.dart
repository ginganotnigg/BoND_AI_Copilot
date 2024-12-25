import 'package:bond/bloc/chat_bloc/chat_bloc.dart';
import 'package:bond/bloc/prompt_bloc/prompt_bloc.dart';
import 'package:bond/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/auth_bloc/auth_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChatBloc()),
        BlocProvider(create: (_) => AuthBloc()),
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
