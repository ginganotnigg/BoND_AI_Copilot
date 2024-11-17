import 'package:bond/global.dart';
import 'package:bond/ui/chat/ai_dropdown.dart';
import 'package:bond/ui/home/home_utils.dart';
import 'package:bond/ui/prompt/prompt_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bond/bloc/chat_bloc/chat_bloc.dart';
import 'package:bond/bloc/chat_bloc/chat_event.dart';
import 'package:go_router/go_router.dart';

class AIChatInput extends StatefulWidget {
  const AIChatInput({super.key});

  @override
  State<AIChatInput> createState() => _AIChatInputState();
}

class _AIChatInputState extends State<AIChatInput> {
  final TextEditingController _controller = TextEditingController();
  String selectedModel = "GPT-4o mini";

  void updateModel(String model) {
    setState(() {
      selectedModel = model;
    });
  }

  void sendMessageToChat(BuildContext context, String message) {
    context.read<ChatBloc>().add(SendMessageEvent(message, selectedModel));
    if (GoRouterState.of(context).uri.toString() != '/ai-chat') {
      context.go('/ai-chat', extra: selectedModel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AIModelDropdown(
              selectedModel: selectedModel,
              onModelSelected: updateModel,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.history, color: primaryColor),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.generating_tokens, color: primaryColor),
                onPressed: () => showPromptManagementDialog(context),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Ask me anything...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: primaryColor),
                onPressed: () {
                  final message = _controller.text.trim();
                  if (message.isNotEmpty) {
                    sendMessageToChat(context, message);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
        footer(context),
      ],
    );
  }
}
