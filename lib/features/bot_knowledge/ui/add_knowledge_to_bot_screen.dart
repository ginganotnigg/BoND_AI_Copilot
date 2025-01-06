import 'package:bond/features/bot_knowledge/bloc/bot_knowledge_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/styles/styles.dart';
import '../../bot/models/bot.dart';
import '../bloc/bot_knowledge_bloc.dart';
import '../bloc/bot_knowledge_state.dart';
import '../models/knowledge_in_bot.dart';

class AddKnowledgeToBotScreen extends StatefulWidget {
  final Bot bot;
  const AddKnowledgeToBotScreen({super.key, required this.bot});

  @override
  State<AddKnowledgeToBotScreen> createState() => _AddKnowledgeToBotScreenState();
}

class _AddKnowledgeToBotScreenState extends State<AddKnowledgeToBotScreen> {
  late List<KnowledgeInBot> knowledge;
  late bool modified;

  @override
  void initState() {
    super.initState();
    knowledge = [];
    modified = false;
  }

  @override
  Widget build(BuildContext context) {
    context.read<ImportKnowledgeBloc>().add(
      GetAllKnowledgeRequested(widget.bot.id),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Add knowledge to ${widget.bot.name}"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            if (modified) {
              context.read<BotKnowledgeBloc>().add(GetKnowledgeInBotsRequested(widget.bot.id));
            }
          },
        ),
      ),
      body: BlocConsumer<ImportKnowledgeBloc, ImportKnowledgeState>(
        listener: (context, state) {
          if (state is KnowledgeLoaded) {
            knowledge = state.knowledge;
          }
          else if (state is KnowledgeModified) {
            context.read<ImportKnowledgeBloc>().add(GetAllKnowledgeRequested(widget.bot.id));
            context.read<BotKnowledgeBloc>().add(GetKnowledgeInBotsRequested(widget.bot.id));
            modified = true;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          else if (state is ImportKnowledgeError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is KnowledgeLoading) {
            return const SizedBox.expand(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is KnowledgeInitial) {
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
          return Container();
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hi there. It seems empty here. Add More Knowledge",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                  onPressed: () {
                    showAddConfirmationDialog(context, k, widget.bot);
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

void showAddConfirmationDialog(BuildContext context, KnowledgeInBot k, Bot bot) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Add Knowledge To Bot"),
        content: Text("Are you sure you want to add ${k.name} to bot ${bot.name}?"),
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
              context.read<ImportKnowledgeBloc>().add(
                AddKnowledgeToBotRequested(bot.id, k.id),
              );
            },
            style: filled,
            child: const Text("Add"),
          ),
        ],
      );
    },
  );
}
