import 'package:flutter/material.dart';
import 'package:bond/global.dart';

Widget buildIconWithText(IconData icon, String text) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: secondaryColor),
      Text(text, style: const TextStyle(color: secondaryColor)),
    ],
  );
}

Widget buildListTile(BuildContext context, String text) {
  return ListTile(
    title: Text(text, style: const TextStyle(color: secondaryColor)),
    trailing: const Icon(Icons.arrow_forward, color: secondaryColor),
    onTap: () {
      showPromptDialog(context, text);
    },
  );
}

void showPromptDialog(BuildContext context, String promptTitle) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Expanded(
                    child: Text(
                      promptTitle,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text("Coding · Jarvis AI Team",
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                "Teach you the code with the most understandable knowledge.",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                child: const Text("View Prompt",
                    style: TextStyle(color: Colors.blue)),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Output Language"),
                  DropdownButton<String>(
                    value: 'Auto',
                    items: <String>[
                      'Auto',
                      'English',
                      'Spanish',
                      'Vietnam',
                      'French'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {},
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "A code snippet or a problem",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Placeholder action for sending
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Send"),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showPublicPromptDialog(BuildContext context) {
  List<Map<String, String>> publicPrompts = [
    {'name': 'Prompt 1', 'description': 'Description for Prompt 1'},
    {'name': 'Prompt 2', 'description': 'Description for Prompt 2'},
  ];
  List<Map<String, String>> privatePrompts = [
    {'name': 'Prompt 1', 'description': 'Description for Prompt 1'},
    {'name': 'Prompt 2', 'description': 'Description for Prompt 2'},
  ];

  String searchText = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: DefaultTabController(
          length: 2,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Prompt Library",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const TabBar(
                  tabs: [
                    Tab(text: 'My Prompts'),
                    Tab(text: 'Public Prompts'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildPromptList(context, publicPrompts, searchText),
                      _buildPromptList(context, privatePrompts, searchText),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildPromptList(BuildContext context, List<Map<String, String>> prompts,
    String searchText) {
  return Column(
    children: [
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  searchText = value;
                },
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showAddPromptDialog(context);
              },
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView(
          children: prompts
              .where((prompt) => prompt['name']!
                  .toLowerCase()
                  .contains(searchText.toLowerCase()))
              .map((prompt) => _buildPromptTile(context, prompt))
              .toList(),
        ),
      ),
    ],
  );
}

Widget _buildPromptTile(BuildContext context, Map<String, String> prompt) {
  return ListTile(
    title: Text(prompt['name']!),
    subtitle: Text(prompt['description']!),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            _showEditPromptDialog(context, prompt);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            // Logic for deleting the prompt
          },
        ),
      ],
    ),
  );
}

void _showAddPromptDialog(BuildContext context) {
  String name = '';
  String prompt = '';
  bool isPrivate = true;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("New Prompt"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleButtons(
              isSelected: [isPrivate, !isPrivate],
              onPressed: (int index) {
                isPrivate = index == 0;
                // Trigger a rebuild
                (context as Element).markNeedsBuild();
              },
              color: Colors.black,
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              borderColor: Colors.grey,
              selectedBorderColor: Colors.blue,
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
            ),
            TextField(
              onChanged: (value) => name = value,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Name of the prompt',
              ),
            ),
            TextField(
              onChanged: (value) => prompt = value,
              decoration: const InputDecoration(
                labelText: 'Prompt',
                hintText: 'Prompt content',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement your add prompt logic here
              // e.g., addPrompt(name, prompt, isPrivate);
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      );
    },
  );
}

void _showEditPromptDialog(BuildContext context, Map<String, String> prompt) {
  String name = prompt['name'] ?? '';
  String content = prompt['description'] ?? '';
  bool isPrivate = prompt['type'] == 'private';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Update Prompt"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToggleButtons(
              isSelected: [isPrivate, !isPrivate],
              onPressed: (int index) {
                isPrivate = index == 0;
                // Trigger a rebuild
                (context as Element).markNeedsBuild();
              },
              color: Colors.black,
              selectedColor: Colors.white,
              fillColor: Colors.blue,
              borderColor: Colors.grey,
              selectedBorderColor: Colors.blue,
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
            ),
            TextField(
              onChanged: (value) => name = value,
              controller: TextEditingController(text: name),
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Name of the prompt',
              ),
            ),
            TextField(
              onChanged: (value) => content = value,
              controller: TextEditingController(text: content),
              decoration: const InputDecoration(
                labelText: 'Prompt',
                hintText: 'Prompt content',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Implement your update prompt logic here
              // e.g., updatePrompt(name, content, isPrivate);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
