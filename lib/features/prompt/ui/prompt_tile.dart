import 'package:bond/shared/styles/styles.dart';
import 'package:bond/features/prompt/models/prompt.dart';
import 'package:flutter/material.dart';
import 'prompt_dialog.dart';
import 'package:bond/features/prompt/bloc/prompt_bloc.dart';
import 'package:bond/features/prompt/bloc/prompt_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromptTile extends StatelessWidget {
  final Prompt prompt;
  final int tabIndex;

  const PromptTile(this.prompt, this.tabIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(prompt.title),
      subtitle: Text(prompt.description),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tabIndex == 0)
            IconButton(
              color: primaryColor,
              icon: const Icon(Icons.edit),
              onPressed: () => showPromptDialog(context, prompt: prompt),
            ),
          if (tabIndex == 0)
            IconButton(
              color: secondaryColor,
              icon: const Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, prompt);
              },
            ),
          if (tabIndex == 1 || tabIndex == 2)
            IconButton(
              color: secondaryColor,
              icon: Icon(prompt.isFavorite as bool
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () {
                context.read<PromptBloc>().add(
                    ToggleFavoritePromptEvent(prompt.id!, !prompt.isFavorite!));
              },
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Prompt prompt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Prompt'),
          content: const Text('Are you sure you want to delete this prompt?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context
                    .read<PromptBloc>()
                    .add(DeletePromptEvent(prompt.id as String));
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
