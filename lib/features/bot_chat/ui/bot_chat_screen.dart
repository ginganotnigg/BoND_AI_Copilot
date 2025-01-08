import 'package:bond/shared/styles/styles.dart';
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

  @override
  void initState() {
    super.initState();

    title = widget.bot.name;
  }

  Widget buildScaffold(BuildContext context) {
    //get thread at start
    context
        .read<BotChatBloc>()
        .add(GetThreadEvent(widget.bot));

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
                  if (state is BotChatInitial) {
                    context
                        .read<BotChatBloc>()
                        .add(GetThreadEvent(widget.bot));
                  }
                  //
                  if (state is BotChatError) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.error)));
                  }
                  //
                  if (state is BotChatResponseReceived) {
                    context
                        .read<BotChatBloc>()
                        .add(GetThreadEvent(widget.bot));
                  }
                  //
                },
                builder: (context, state) {
                  if (state is BotChatLoading) {
                    return const SizedBox.expand(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state is BotChatResponseWaiting
                        ? state.conv.messages.length + 1 // add extra line for progress indicator
                        : state.conv.messages.length,
                    itemBuilder: (context, index) {
                      if (state is BotChatResponseWaiting && index == 0) {
                        // if bot chat response waiting, last item is CircularProgressIndicator
                        return const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      //role handling
                      final message = state.conv.messages[
                      state is BotChatResponseWaiting ? index - 1 : index];
                      return Align(
                        alignment: message.role == 'user'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7),
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
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    widget.bot.name,
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
                                    p: const TextStyle(color: Color(0xFF720F5E)),
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
              child: BotChatInput(widget.bot),
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
