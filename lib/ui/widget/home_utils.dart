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

Widget footer(BuildContext context, int remainingTokens) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildIconWithText(Icons.bolt, remainingTokens.toString()),
        const SizedBox(width: 10),
        buildIconWithText(Icons.rocket, "Upgrade"),
        const SizedBox(width: 10),
        IconButton(
          color: secondaryColor,
          icon: const Icon(Icons.star_border),
          onPressed: () {
            // Placeholder for favorite/star icon
          },
        ),
        IconButton(
          color: secondaryColor,
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            // Placeholder for help icon
          },
        ),
        IconButton(
          color: secondaryColor,
          icon: const Icon(Icons.mail_outline),
          onPressed: () {
            // Placeholder for mail icon
          },
        ),
        IconButton(
          color: secondaryColor,
          icon: const Icon(Icons.devices),
          onPressed: () {
            // Placeholder for devices icon
          },
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Center(child: Text("A")),
        ),
      ],
    ),
  );
}
