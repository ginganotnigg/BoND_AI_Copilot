import 'package:flutter/material.dart';

class AddKnowledgeDialog extends StatefulWidget {
  final Function(String, String) onSave;
  final String initialTitle;
  final String initialDescription;

  const AddKnowledgeDialog({
    super.key,
    required this.onSave,
    this.initialTitle = '',
    this.initialDescription = '',
  });

  @override
  State<AddKnowledgeDialog> createState() => _AddKnowledgeDialogState();
}

class _AddKnowledgeDialogState extends State<AddKnowledgeDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  bool _isTitleValid = false;
  bool _isDescriptionValid = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialTitle);
    _descriptionController =
        TextEditingController(text: widget.initialDescription);
    _isTitleValid = widget.initialTitle.isNotEmpty;
    _isDescriptionValid = widget.initialDescription.isNotEmpty;
  }

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
    return AlertDialog(
      title: widget.initialTitle == ''
          ? const Text('Add Knowledge')
          : const Text('Edit Knowledge'),
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
            maxLines: 5,
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
        TextButton(
          onPressed: _isTitleValid && _isDescriptionValid
              ? () {
                  final title = _nameController.text;
                  final description = _descriptionController.text;
                  widget.onSave(title, description);
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
