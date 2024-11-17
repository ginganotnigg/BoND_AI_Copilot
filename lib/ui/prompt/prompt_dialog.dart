import 'package:bond/global.dart';
import 'package:bond/models/prompt.dart';
import 'package:flutter/material.dart';

void showPromptDialog(BuildContext context,
    {Prompt? prompt, bool isEdit = true}) {
  // Use StatefulWidget to retain the 'isPrivate' state
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
  late String name;
  late String description;
  late String content;
  late bool isPrivate;
  PromptCategory? category;
  String? language;

  final List<PromptCategory> categoryOptions = PromptCategory.values;

  @override
  void initState() {
    super.initState();
    name = widget.prompt?.title ?? '';
    description = widget.prompt?.description ?? '';
    content = widget.prompt?.content ?? '';
    isPrivate = widget.prompt?.isPublic == false;
    category = widget.prompt?.category ??
        categoryOptions.first; // Set default category
    language = widget.prompt?.language ?? 'English'; // Set default language
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
            onChanged: (value) => setState(() => name = value),
            controller: TextEditingController(text: name),
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'Title of the prompt',
            ),
          ),
          // Use TextFormField with maxLines for longer input (description)
          TextFormField(
            onChanged: (value) => setState(() => description = value),
            controller: TextEditingController(text: description),
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Prompt description',
            ),
            maxLines: 4, // Allow multi-line input
            keyboardType: TextInputType.multiline,
          ),
          // Use TextFormField with maxLines for longer input (content)
          TextFormField(
            onChanged: (value) => setState(() => content = value),
            controller: TextEditingController(text: content),
            decoration: const InputDecoration(
              labelText: 'Content',
              hintText: 'Prompt content',
            ),
            maxLines: 6, // Allow multi-line input for longer content
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
                  child: Text(category
                      .toString()
                      .split('.')
                      .last), // Display enum as string
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  category =
                      value ?? categoryOptions.first; // Set fallback value
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
                  language = value ?? 'English'; // Set fallback value
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
            // Implement add/update prompt logic here
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
