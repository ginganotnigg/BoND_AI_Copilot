import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/styles/styles.dart';
import '../bloc/bot_bloc.dart';
import '../bloc/bot_event.dart';

class AddBotScreen extends StatelessWidget {
  const AddBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Bot"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  labelText: "Bot Name",
                  hintText: 'Enter assistant name',
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                  labelText: "Bot Description",
                  hintText: 'Enter description',
              ),
              maxLines: 5,
              maxLength: 2000,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<BotBloc>().add(
                  CreateBotRequested(nameController.text, descriptionController.text),
                );
              },
              style: filled,
              child: const Text("Create"),
            ),
          ],
        ),
      ),
    );
  }
}
