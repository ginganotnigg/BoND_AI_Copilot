import 'package:bond/global.dart';
import 'package:bond/utils/home_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bond/bloc/chat_bloc/chat_bloc.dart';
import 'package:bond/bloc/chat_bloc/chat_event.dart';
import 'package:go_router/go_router.dart';

class AIChatInput extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  AIChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.generating_tokens, color: primaryColor),
            onPressed: () => showPublicPromptDialog(context),
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
              final message = _controller.text;
              if (message.isNotEmpty) {
                context
                    .read<ChatBloc>()
                    .add(SendMessage(message: message, type: 'user'));
                context.go('/ai-chat');
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
