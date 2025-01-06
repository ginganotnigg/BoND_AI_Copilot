import 'package:bond/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bot/models/bot.dart';
import '../bloc/chat_bloc/bot_chat_bloc.dart';
import '../bloc/chat_bloc/bot_chat_event.dart';

class BotChatInput extends StatefulWidget {
  final Bot bot;
  const BotChatInput(this.bot, {super.key});

  @override
  State<BotChatInput> createState() => _BotChatInputState();
}

class _BotChatInputState extends State<BotChatInput> {
  final TextEditingController _controller = TextEditingController();

  void sendMessageToChat(BuildContext context, String message, ) {
    context
        .read<BotChatBloc>()
        .add(SendMessageEvent(message, widget.bot));
  }

  String formatTimestamp(int timestampInSeconds) {
    DateTime conversationDateTime =
        DateTime.fromMillisecondsSinceEpoch(timestampInSeconds * 1000);
    DateTime now = DateTime.now();
    Duration difference = now.difference(conversationDateTime);
    return formatDuration(difference);
  }

  String formatDuration(Duration duration) {
    StringBuffer buffer = StringBuffer();

    if (duration.inDays > 365) {
      int years = duration.inDays ~/ 365;
      buffer.write('$years year${years > 1 ? 's' : ''} ago');
    } else if (duration.inDays > 30) {
      int months = duration.inDays ~/ 30;
      buffer.write('$months month${months > 1 ? 's' : ''} ago');
    } else if (duration.inDays > 0) {
      buffer
          .write('${duration.inDays} day${duration.inDays > 1 ? 's' : ''} ago');
    } else if (duration.inHours > 0) {
      buffer.write(
          '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''} ago');
    } else if (duration.inMinutes > 0) {
      buffer.write(
          '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''} ago');
    } else {
      buffer.write(
          '${duration.inSeconds} second${duration.inSeconds > 1 ? 's' : ''} ago');
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Ask bot',
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
      ],
    );
  }
}
