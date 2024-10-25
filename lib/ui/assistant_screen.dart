import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bond/ui/create_bot.dart';

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
            _buildFeatureList(context),
            // Add more widgets as per your UI design
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action to create a new bot
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateBotScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Create Bot"),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Icon(Icons.integration_instructions),
          title: Text("Multi-Source Knowledge Integration 📚"),
          subtitle: Text(
              "Seamlessly integrate various types of knowledge from multiple data sources such as Websites, Google Drive, GitHub, GitLab, Notion, and more."),
        ),
        ListTile(
          leading: Icon(Icons.developer_mode),
          title: Text("Comprehensive SDK 🛠️"),
          subtitle: Text(
              "Our SDK provides the tools and resources needed to integrate chatbots into your own applications with ease."),
        ),
        // Add more features in the list
      ],
    );
  }
}
