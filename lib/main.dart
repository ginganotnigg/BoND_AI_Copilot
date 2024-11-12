import 'package:bond/bloc/chat_bloc/chat_bloc.dart';
import 'package:bond/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider(
    create: (_) => ChatBloc(),
    child: const BondAI(),
  ));
}

class BondAI extends StatelessWidget {
  const BondAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bond AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Arya'),
      routerConfig: router,
    );
  }
}