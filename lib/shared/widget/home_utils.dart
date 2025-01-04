import 'package:bond/features/chat/bloc/chat_bloc/chat_bloc.dart';
import 'package:bond/features/chat/bloc/chat_bloc/chat_event.dart';
import 'package:bond/features/prompt/models/prompt.dart';
import 'package:bond/shared/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:bond/shared/styles/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_event.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../features/auth/models/user.dart';
import '../helpers/auth_helper.dart';

Widget buildIconWithText(IconData icon, String text) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: secondaryColor),
      Text(text, style: const TextStyle(color: secondaryColor)),
    ],
  );
}

Widget buildIconWithTextLink(
    BuildContext context, IconData icon, String text, String link) {
  return GestureDetector(
    onTap: () {
      context.go(link);
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: secondaryColor),
        Text(text, style: const TextStyle(color: secondaryColor)),
      ],
    ),
  );
}

Widget buildListTile(BuildContext context, String text) {
  return ListTile(
    title: Text(text, style: const TextStyle(color: secondaryColor)),
    trailing: const Icon(Icons.arrow_forward, color: secondaryColor),
    onTap: () {
      // showPromptDialog(context, text);
    },
  );
}

void showPromptDialog(BuildContext context, Prompt prompt) {
  TextEditingController promptContentController = TextEditingController();
  List<TextEditingController> inputControllers =
      []; // List for dynamic TextFields
  List<String> inputHints = []; // List to store input hints for each field

  // Extract inputs (the parts inside [])
  RegExp regExp = RegExp(r'\[([^\]]+)\]');
  Iterable<Match> matches = regExp.allMatches(prompt.content);

  // Clear existing controllers and inputs
  inputControllers.clear();
  inputHints.clear();

  for (var match in matches) {
    String inputHint = match.group(1) ?? ''; // Extract the hint (e.g., "Topic")
    inputHints.add(inputHint);
    inputControllers.add(TextEditingController());
  }

  promptContentController.text = prompt.content;

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
                      prompt.title,
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
              Text(
                '${capitalize(prompt.category.name)} · ${capitalize(prompt.userName ?? 'AI Jarvis Team')}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                prompt.description,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 10),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextField(
                  controller: promptContentController,
                  maxLines: 3,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Prompt Content',
                  ),
                ),
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
              // Display dynamic input fields for each extracted input
              ...List.generate(inputControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextField(
                    controller: inputControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Enter ${inputHints[index]}',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Replace placeholders in prompt.content with user inputs
                  String updatedPrompt = prompt.content;
                  for (int i = 0; i < inputControllers.length; i++) {
                    updatedPrompt = updatedPrompt.replaceFirst(
                      RegExp(r'\[([^\]]+)\]'),
                      inputControllers[i].text.isNotEmpty
                          ? inputControllers[i].text
                          : inputHints[i],
                    );
                  }

                  context
                      .read<ChatBloc>()
                      .add(SendMessageEvent(updatedPrompt, 'GPT-4o mini'));
                  // if (GoRouterState.of(context).uri.toString() != '/ai-chat') {
                  context.go('/ai-chat',
                      extra: {'model': 'GPT-4o mini', 'conversationId': null});
                  // }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryColor,
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
        buildIconWithTextLink(
            context, Icons.rocket, "Upgrade", "/pricing-plan"),
        const SizedBox(width: 10),
        buildIconWithTextLink(context, Icons.email, "Email", "/ai-email"),
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
        userContainer(context), // Updated user container
      ],
    ),
  );
}

Future<User> getUserInfo() async {
  String username = await AuthHelper.getName() ?? 'Unknown';
  String email = await AuthHelper.getEmail() ?? '';
  return User(username, email);
}

Widget userContainer(BuildContext context) {
  return FutureBuilder<User>(
    future: getUserInfo(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      } else if (snapshot.hasError || !snapshot.hasData) {
        return const Text("Error");
      } else {
        final userInfo = snapshot.data!;
        final username = userInfo.name;
        final email = userInfo.email;
        final displayChar =
            (username.isNotEmpty && RegExp(r'^[a-zA-Z]').hasMatch(username[0]))
                ? username[0].toUpperCase()
                : '?';
        return GestureDetector(
          onTap: () => showUserDialog(context, username, email),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                displayChar,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }
    },
  );
}

void showUserDialog(BuildContext context, String username, String email) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Center(child: Text(username)),
        content: Container(
          height: 110, // Set your desired height here
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(email, style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    context.go('/assistant');
                  },
                  style: filled,
                  child: const Text("My Bots"),
                ),
                const SizedBox(height: 8),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: ((context, state) {
                    if (state is Unauthenticated) {
                      context.go('/login');
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.message)));
                    } else if (state is AuthError) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.error)));
                    }
                  }),
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const SignOutRequested(),
                            );
                      },
                      style: outlined,
                      child: const Text("Sign Out"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
