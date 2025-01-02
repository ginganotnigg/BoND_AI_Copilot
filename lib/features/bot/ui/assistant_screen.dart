import 'package:bond/shared/widget/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/styles/styles.dart';
import '../../bot_knowledge/ui/knowledge_in_bot_screen.dart';
import '../bloc/bot_bloc.dart';
import '../bloc/bot_event.dart';
import '../bloc/bot_state.dart';
import '../models/bot.dart';
import 'add_bot_screen.dart';
import 'edit_bot_screen.dart';

class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  late List<Bot> bots;
  late List<Bot> filteredBots;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bots = [];
    filteredBots = [];
  }

  void _filterBots() {
    context.read<BotBloc>().add(
      SearchBotsRequested(bots, searchController.text)
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<BotBloc>().add(
      const GetBotsRequested(),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Bots"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: BlocConsumer<BotBloc, BotState>(
        listener: (context, state) {
          if (state is BotLoaded) {
            bots = state.bots;
            filteredBots = bots;
          }
          else if (state is BotSearched) {
            filteredBots = state.bots;
          }
          else if (state is BotModified) {
            context.read<BotBloc>().add(const GetBotsRequested());
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          else if (state is BotError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is BotLoading) {
            return const SizedBox.expand(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is BotInitial) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search by name or description",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (_) => _filterBots(),
                  ),
                ),
                Expanded(
                  child: bots.isEmpty
                      ? _buildEmptyState(context)
                      : _buildBotList(context),
                ),
              ],
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddBotScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Create Bot"),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hi, welcome aboard 🚀",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Bond KB is a cutting-edge AI App development platform designed. With Bond KB, you can effortlessly create and deploy various chatbots across numerous social platforms and messaging apps like Messenger, Telegram, and Slack!",
          ),
          const SizedBox(height: 16),
          featureList(context),
        ],
      ),
    );
  }

  Widget _buildBotList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredBots.length + 1,
      itemBuilder: (context, index) {
        if (index == filteredBots.length) {
          return const SizedBox(height: 80);
        }
        final bot = filteredBots[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              bot.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bot.description),
                const SizedBox(height: 4),
                Text(
                  "Last updated: ${bot.updatedAt}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.storage),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeInBotScreen(bot: bot),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBotScreen(bot: bot),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDeleteConfirmationDialog(context, bot);
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


void showDeleteConfirmationDialog(BuildContext context, Bot bot) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Bot"),
        content: Text("Are you sure you want to delete ${bot.name}?"),
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
              context.read<BotBloc>().add(
                DeleteBotRequested(bot.id),
              );
            },
            style: filled,
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
}
