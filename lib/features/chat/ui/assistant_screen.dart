import 'package:bond/shared/widget/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AssistantScreen extends StatelessWidget {
  const AssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add AI Assistant"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Container(
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
            // Add more widgets as per your UI design
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/create-bot');
        },
        icon: const Icon(Icons.add),
        label: const Text("Create Bot"),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
