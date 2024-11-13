import 'package:bond/global.dart';
import 'package:bond/models/prompt.dart';
import 'package:flutter/material.dart';
import 'prompt_dialog.dart';

class PromptTile extends StatelessWidget {
  final Prompt prompt;

  const PromptTile(this.prompt, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(prompt.title),
      subtitle: Text(prompt.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!prompt.isPublic)
            IconButton(
              color: primaryColor,
              icon: const Icon(Icons.edit),
              onPressed: () => showPromptDialog(context, prompt: prompt),
            ),
          if (!prompt.isPublic)
            IconButton(
              color: secondaryColor,
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}
