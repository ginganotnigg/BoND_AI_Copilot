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
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Prompt Library",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
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
                        // Logic for adding new prompt
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildPromptTile("Revise Sentences",
                        "Hãy sửa lại các câu của tôi cho đúng cú pháp trong tiếng anh"),
                    _buildPromptTile("Recognize Language",
                        "Identify the language of the input text."),
                    _buildPromptTile("Improve Sentence",
                        "Help improve the given sentence for better clarity."),
                    _buildPromptTile(
                        "Translate RU", "Translate the text to Russian."),
                    // More prompt tiles...
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Helper function to build individual prompt tiles
Widget _buildPromptTile(String title, String description) {
  return ListTile(
    title: Text(title),
    subtitle: Text(description),
    trailing: const Icon(Icons.arrow_forward),
    onTap: () {
      // Handle prompt selection logic
    },
  );
}
