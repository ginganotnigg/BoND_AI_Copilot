import 'package:bond/shared/styles/styles.dart';
import 'package:bond/shared/widget/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

import '../../bot/models/bot.dart';
import '../bloc/chat_bloc/bot_chat_bloc.dart';
import '../bloc/chat_bloc/bot_chat_state.dart';
import '../bloc/chat_bloc/bot_chat_event.dart';
import 'bot_chat_input.dart';

class BotChatScreen extends StatefulWidget {
  final Bot bot;

  const BotChatScreen(this.bot, {super.key});

  @override
  State<BotChatScreen> createState() => _BotChatScreenState();
}

class _BotChatScreenState extends State<BotChatScreen> {
  String title = "Bot";
  Bot bot = Bot("","","","","","");

  @override
  void initState() {
    super.initState();
    Bot bot = Bot(
        widget.bot.updatedAt,
        widget.bot.id,
        widget.bot.name,
        widget.bot.aiId,
        widget.bot.description,
        widget.bot.thread
    );

    title = bot.name;

    context
        .read<BotChatBloc>()
        .add(CreateThreadEvent(bot));
  }

  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<BotChatBloc, BotChatState>(
                listener: (context, state) {
                  if (state is BotThreadLoaded) {
                    bot = state.bot;
                    context
                        .read<BotChatBloc>()
                        .add(GetThreadEvent(bot));
                  }
                  if (state is BotChatError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                    bot = Bot(
                        widget.bot.updatedAt,
                        widget.bot.id,
                        widget.bot.name,
                        widget.bot.aiId,
                        widget.bot.description,
                        ""
                    );
                    context
                        .read<BotChatBloc>()
                        .add(GetThreadEvent(bot));
                  }
                },
                builder: (context, state) {
                  if (state is BotChatLoading &&
                      state.conv.messages.isEmpty) {
                    return loadingWidget();
                  }
                  if (state is BotThreadLoading &&
                      state.conv.messages.isEmpty) {
                    return loadingWidget();
                  }
                  return ListView.builder(
                    reverse: false,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.conv.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.conv.messages[index];
                      return Align(
                        alignment: message.role == 'user'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: message.role == 'user'
                                ? primaryColor.withOpacity(0.5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.role != 'user')
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    bot.name,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              if (message.role == 'user')
                                Text(
                                  message.content,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                              else
                                MarkdownBody(
                                  data: message.content,
                                  styleSheet: MarkdownStyleSheet(
                                    p: const TextStyle(
                                        color: Color(0xFF720F5E)),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // AIBotChatInput fixed at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: BotChatInput(bot),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildScaffold(context);
  }
}
