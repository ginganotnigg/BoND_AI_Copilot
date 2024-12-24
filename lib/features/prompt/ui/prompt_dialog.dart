import 'package:bond/features/prompt/bloc/prompt_bloc.dart';
import 'package:bond/features/prompt/bloc/prompt_event.dart';
import 'package:bond/shared/styles/styles.dart';
import 'package:bond/features/prompt/models/prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showPromptDialog(BuildContext context,
    {Prompt? prompt, bool isEdit = true}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return _PromptDialog(
        prompt: prompt,
        isEdit: isEdit,
      );
    },
  );
}

class _PromptDialog extends StatefulWidget {
  final Prompt? prompt;
  final bool isEdit;

  const _PromptDialog({required this.prompt, required this.isEdit});

  @override
  _PromptDialogState createState() => _PromptDialogState();
}

class _PromptDialogState extends State<_PromptDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController contentController;
  late bool isPrivate;
  PromptCategory? category;
  String? language;

  final List<PromptCategory> categoryOptions = PromptCategory.values;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.prompt?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.prompt?.description ?? '');
    contentController =
        TextEditingController(text: widget.prompt?.content ?? '');
    isPrivate = widget.prompt?.isPublic == false;
    category = widget.prompt?.category ?? categoryOptions.first;
    language = widget.prompt?.language ?? 'English';
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        widget.isEdit ? "Update Prompt" : "New Prompt",
        style: const TextStyle(fontSize: 18, fontFamily: 'Arya'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ToggleButtons for private/public state
          _ToggleButtons(
            isPrivate: isPrivate,
            onChanged: (newIsPrivate) {
              setState(() {
                isPrivate = newIsPrivate;
              });
            },
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Title of the prompt',
            ),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Prompt description',
            ),
            maxLines: 4,
            keyboardType: TextInputType.multiline,
          ),
          TextFormField(
            controller: contentController,
            decoration: const InputDecoration(
              labelText: 'Content',
              hintText: 'Prompt content',
            ),
            maxLines: 6,
            keyboardType: TextInputType.multiline,
          ),
          // Display category and language dropdowns only for public mode
          if (!isPrivate) ...[
            DropdownButton<PromptCategory>(
              value: category,
              hint: const Text('Select Category'),
              isExpanded: true,
              items: categoryOptions.map((PromptCategory category) {
                return DropdownMenuItem<PromptCategory>(
                  value: category,
                  child:
                      Text(category.toString().split('.').last.toUpperCase()),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  category = value ?? categoryOptions.first;
                });
              },
            ),
            DropdownButton<String>(
              value: language,
              hint: const Text('Select Language'),
              isExpanded: true,
              items:
                  ['English', 'Vietnamese', 'Spanish'].map((String language) {
                return DropdownMenuItem<String>(
                  value: language,
                  child: Text(language),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  language = value ?? 'English';
                });
              },
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          style: outlined,
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: filled,
          onPressed: () {
            if (widget.isEdit) {
              // Update an existing prompt
              final updatedPrompt = Prompt(
                title: nameController.text,
                description: descriptionController.text,
                content: contentController.text,
                isPublic: !isPrivate,
                category: category!,
                language: language!,
              );

              context
                  .read<PromptBloc>()
                  .add(UpdatePromptEvent(widget.prompt!.id!, updatedPrompt));
            } else {
              // Add a new prompt
              final newPrompt = Prompt(
                title: nameController.text,
                description: descriptionController.text,
                content: contentController.text,
                isPublic: !isPrivate,
                category: category!,
                language: language!,
              );
              context.read<PromptBloc>().add(CreatePromptEvent(newPrompt));
            }

            Navigator.pop(context);
          },
          child: Text(widget.isEdit ? "Save" : "Create"),
        ),
      ],
    );
  }
}

class _ToggleButtons extends StatelessWidget {
  final bool isPrivate;
  final ValueChanged<bool> onChanged;

  const _ToggleButtons({required this.isPrivate, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: [isPrivate, !isPrivate],
      onPressed: (index) {
        onChanged(index == 0); // Pass true for private, false for public
      },
      selectedColor: primaryColor,
      borderRadius: BorderRadius.circular(8.0),
      children: const [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Private"),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text("Public"),
        ),
      ],
    );
  }
}
