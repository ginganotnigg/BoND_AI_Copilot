import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_bloc.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_event.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_state.dart';

class AddKnowledgeDialog extends StatefulWidget {
  const AddKnowledgeDialog({super.key});

  @override
  State<AddKnowledgeDialog> createState() => _AddKnowledgeDialogState();
}

class _AddKnowledgeDialogState extends State<AddKnowledgeDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isTitleValid = false;
  bool _isDescriptionValid = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _validateTitle(String value) {
    setState(() {
      _isTitleValid = value.isNotEmpty;
    });
  }

  void _validateDescription(String value) {
    setState(() {
      _isDescriptionValid = value.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KnowledgeBloc()..add(FetchKnowledgeEvent()),
      child: AlertDialog(
        title: const Text('Add Knowledge'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: _validateTitle,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: _validateDescription,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          BlocConsumer<KnowledgeBloc, KnowledgeState>(
            listener: (context, state) {
              if (state is KnowledgeLoaded) {
                Navigator.of(context).pop();
              } else if (state is KnowledgeError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              }
            },
            builder: (context, state) {
              if (state is KnowledgeLoading) {
                return const CircularProgressIndicator();
              }
              return TextButton(
                onPressed: _isTitleValid && _isDescriptionValid
                    ? () {
                        final title = _nameController.text;
                        final description = _descriptionController.text;
                        context.read<KnowledgeBloc>().add(
                              AddKnowledgeEvent(title, description),
                            );
                      }
                    : null,
                child: const Text('Add'),
              );
            },
          ),
        ],
      ),
    );
  }
}
