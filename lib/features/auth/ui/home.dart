import 'package:bond/shared/styles/styles.dart';
import 'package:bond/features/chat/ui/chat_input.dart';
import 'package:bond/shared/widget/home_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/helpers/auth_helper.dart';

class HomeScreen extends StatefulWidget {
  final bool isLoggedIn;
  const HomeScreen({super.key, required this.isLoggedIn});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedModel = 'GPT-4o mini';

  void onModelChanged(String newModel) {
    setState(() {
      selectedModel = newModel;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLoggedInStatus();
  }

  Future<void> _checkLoggedInStatus() async {
    final isLoggedIn = await AuthHelper.getLoggedInStatus() ?? false;
    if (isLoggedIn) {
      if (mounted) {
        context.go('/');
      }
    }
    else {
      if (mounted) {
        context.go('/welcome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
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
                          if (!widget.isLoggedIn)
                            ElevatedButton(
                              onPressed: () {
                                context.go('/register');
                              },
                              style: outlined,
                              child: const Text("Sign up Now"),
                            ),
                          if (!widget.isLoggedIn) const SizedBox(width: 10), // Add spacing only if the button is present
                          ElevatedButton(
                            onPressed: () {
                              context.go('/pricing-plan');
                            },
                            style: filled,
                            child: const Text("Start Free Trial"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Don't know what to say? Use a prompt!",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                buildListTile(context, "Grammar corrector"),
                buildListTile(context, "Learn Code FAST!"),
                buildListTile(context, "Story generator"),
                const SizedBox(height: 20),
                AIChatInput(
                  remainingTokens: 50,
                  selectedModel: selectedModel,
                  onModelChanged: onModelChanged,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
