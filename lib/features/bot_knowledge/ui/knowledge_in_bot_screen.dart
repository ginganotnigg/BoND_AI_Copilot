import 'package:bond/features/bot_knowledge/bloc/bot_knowledge_event.dart';
import 'package:bond/features/bot_knowledge/ui/add_knowledge_to_bot_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/styles/styles.dart';
import '../../bot/models/bot.dart';
import '../bloc/bot_knowledge_bloc.dart';
import '../bloc/bot_knowledge_state.dart';
import '../models/knowledge_in_bot.dart';

class KnowledgeInBotScreen extends StatefulWidget {
  final Bot bot;
  const KnowledgeInBotScreen({super.key, required this.bot});

  @override
  State<KnowledgeInBotScreen> createState() => _KnowledgeInBotScreenState();
}

class _KnowledgeInBotScreenState extends State<KnowledgeInBotScreen> {
  late List<KnowledgeInBot> knowledge;

  @override
  void initState() {
    super.initState();
    knowledge = [];
  }

  @override
  Widget build(BuildContext context) {
    context.read<BotKnowledgeBloc>().add(
      GetKnowledgeInBotsRequested(widget.bot.id),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.bot.name}'s knowledge"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocConsumer<BotKnowledgeBloc, BotKnowledgeState>(
        listener: (context, state) {
          if (state is BotKnowledgeLoaded) {
              knowledge = state.knowledge;
          }
          if (state is BotKnowledgeModified) {
            context.read<BotKnowledgeBloc>().add(GetKnowledgeInBotsRequested(widget.bot.id));
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is BotKnowledgeError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is BotKnowledgeLoading) {
            return const SizedBox.expand(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is BotKnowledgeInitial) {
            knowledge = state.knowledge;
            return Column(
              children: [
                Expanded(
                  child: knowledge.isEmpty
                      ? _buildEmptyState(context)
                      : _buildBotList(context),
                ),
              ],
            );
          }
          return _buildEmptyState(context);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddKnowledgeToBotScreen(bot: widget.bot),
            ),
          );

        },
        icon: const Icon(Icons.add),
        label: const Text("Import Knowledge"),
        backgroundColor: Colors.blueAccent,
      )
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi there. It seems empty here. Import Knowledge for ${widget.bot.name} if you like to!",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBotList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: knowledge.length + 1,
      itemBuilder: (context, index) {
        if (index == knowledge.length) {
          return const SizedBox(height: 80);
        }
        final k = knowledge[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              k.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(k.description),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    //Navigate to single knowledge screen
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  color: Colors.red,
                  onPressed: () {
                    showDeleteConfirmationDialog(context, k, widget.bot);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


void showDeleteConfirmationDialog(BuildContext context, KnowledgeInBot k, Bot bot) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Remove Knowledge From Bot"),
        content: Text("Are you sure you want to remove ${k.name} from bot ${bot.name}?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: outlined,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<BotKnowledgeBloc>().add(
                RemoveKnowledgeFromBotRequested(bot.id, k.id),
              );
            },
            style: filled,
            child: const Text("Remove"),
          ),
        ],
      );
    },
  );
}
