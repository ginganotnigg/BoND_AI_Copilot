import 'package:bond/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bond/utils/home_utils.dart';

void main() {
  runApp(const BondAI());
}

class BondAI extends StatelessWidget {
  const BondAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Bond AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: router,
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _buildIconWithText(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        Text(text),
      ],
    );
  }

  Widget _buildListTile(BuildContext context, String text) {
    return ListTile(
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward),
      onTap: () {
        showPromptDialog(context, text);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              "👋 Hi!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "I'm Bond, your personal assistant.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  const Text(
                    "Create an account to earn bonus tokens for using Bond AI, or upgrade to the Pro version for unlimited access with a 1-month free trial!",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          side: const BorderSide(color: Colors.blue),
                        ),
                        child: const Text("Sign up Now"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Placeholder action for "Start Free Trial"
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Start Free Trial"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Text("Don't know what to say? Use a prompt!",
                style: TextStyle(fontSize: 16)),
            _buildListTile(context, "Grammar corrector"),
            _buildListTile(context, "Learn Code FAST!"),
            _buildListTile(context, "Story generator"),
            const Spacer(),
            DropdownButton<String>(
              value: 'GPT-4o mini',
              items: <String>[
                'GPT-4o mini',
                'GPT-4o',
                'Claude 3 Haiku',
                'Claude 3.5 Sonnet',
                'Gemini 1.5 Flash',
                'Gemini 1.5 Pro'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {},
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.generating_tokens),
                    onPressed: () {
                      // Placeholder action for chat bubble icon
                    },
                  ),
                  const Expanded(
                    child: TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Ask me anything, press '/' for prompts...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Placeholder action for send icon
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIconWithText(Icons.bolt, "30"),
                  _buildIconWithText(Icons.rocket, "Upgrade"),
                  IconButton(
                    icon: const Icon(Icons.star_border),
                    onPressed: () {
                      // Placeholder for favorite/star icon
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline),
                    onPressed: () {
                      // Placeholder for help icon
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.mail_outline),
                    onPressed: () {
                      // Placeholder for mail icon
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.devices),
                    onPressed: () {
                      // Placeholder for devices icon
                    },
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text("A"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
