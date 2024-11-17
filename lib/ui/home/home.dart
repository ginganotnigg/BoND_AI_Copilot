import 'package:bond/global.dart';
import 'package:bond/ui/chat/chat_input.dart';
import 'package:bond/ui/home/home_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedModel = 'GPT-4o mini';

  void onModelSelected(String model) {
    setState(() {
      selectedModel = model;
    });
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
                          context.go('/register');
                        },
                        style: outlined,
                        child: const Text("Sign up Now"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          context.go('/pricing-plan');
                        },
                        style: filled,
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
            buildListTile(context, "Grammar corrector"),
            buildListTile(context, "Learn Code FAST!"),
            buildListTile(context, "Story generator"),
            const Spacer(),
            const AIChatInput(),
          ],
        ),
      ),
    );
  }
}
