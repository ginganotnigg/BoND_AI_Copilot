import 'package:bond/features/knowledge_base/bloc/knowledge_bloc.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_event.dart';
import 'package:bond/features/knowledge_base/ui/knowledge_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bot/ui/bot_screen.dart';

class BotsAndKnowledgeScreen extends StatefulWidget {
  const BotsAndKnowledgeScreen({super.key});

  @override
  State<BotsAndKnowledgeScreen> createState() => _BotsAndKnowledgeScreenState();
}

class _BotsAndKnowledgeScreenState extends State<BotsAndKnowledgeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Assistant'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            context.go('/');
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.smart_toy), text: 'Bots'),
            Tab(icon: Icon(Icons.library_books), text: 'Knowledge Base'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const BotScreen(),
          BlocProvider(
            create: (_) => KnowledgeBloc()..add(FetchKnowledgeEvent()),
            child: const KnowledgeScreen(),
          ),
        ],
      ),
    );
  }
}
