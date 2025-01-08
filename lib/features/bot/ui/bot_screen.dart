import 'package:bond/features/bot_chat/ui/bot_chat_screen.dart';
import 'package:bond/shared/widget/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/styles/styles.dart';
import '../../../shared/widget/custom_search_bar.dart';
import '../../bot_knowledge/ui/knowledge_in_bot_screen.dart';
import '../bloc/bot_bloc.dart';
import '../bloc/bot_event.dart';
import '../bloc/bot_state.dart';
import '../models/bot.dart';
import 'add_bot_screen.dart';
import 'edit_bot_screen.dart';

class BotScreen extends StatefulWidget {
  const BotScreen({super.key});

  @override
  State<BotScreen> createState() => _BotScreenState();
}

class _BotScreenState extends State<BotScreen> {
  late List<Bot> bots;
  late List<Bot> filteredBots;

  @override
  void initState() {
    super.initState();
    bots = [];
    filteredBots = [];
  }

  void _filterBots(query) {
    context.read<BotBloc>().add(SearchBotsRequested(bots, query));
  }

  @override
  Widget build(BuildContext context) {
    context.read<BotBloc>().add(
          const GetBotsRequested(),
        );
    return Scaffold(
      body: BlocConsumer<BotBloc, BotState>(
        listener: (context, state) {
          if (state is BotLoaded) {
            bots = state.bots;
            filteredBots = bots;
          }
          if (state is BotSearched) {
            filteredBots = state.bots;
          }
          if (state is BotModified) {
            context.read<BotBloc>().add(const GetBotsRequested());
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is BotError) {
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
                Row(
                  children: [
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          return customSearchBar(context, (query) {
                            _filterBots(query);
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: primaryColor),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => const AddBotScreen(),
                        );
                      },
                    ),
                  ],
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
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: primaryColor),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bot.description,
                  style: const TextStyle(color: primaryColor),
                ),
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
                  icon: const Icon(Icons.chat, color: primaryColor),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BotChatScreen(bot),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.library_books, color: primaryColor),
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
                  icon: const Icon(Icons.edit, color: primaryColor),
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
                  icon: const Icon(Icons.delete, color: primaryColor),
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
