import 'package:bond/bloc/prompt_bloc/prompt_bloc.dart';
import 'package:bond/bloc/prompt_bloc/prompt_event.dart';
import 'package:bond/bloc/prompt_bloc/prompt_state.dart';
import 'package:bond/global.dart';
import 'package:bond/ui/chat/ai_dropdown.dart';
import 'package:bond/ui/widget/home_utils.dart';
import 'package:bond/ui/prompt/prompt_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bond/bloc/chat_bloc/chat_bloc.dart';
import 'package:bond/bloc/conv_bloc/conv_bloc.dart';
import 'package:bond/bloc/chat_bloc/chat_event.dart';
import 'package:go_router/go_router.dart';

class AIChatInput extends StatefulWidget {
  final int remainingTokens;
  const AIChatInput({super.key, required this.remainingTokens});

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
      context.go('/ai-chat',
          extra: {'model': selectedModel, 'conversationId': null});
    }
  }

  void showConversationHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return BlocProvider(
          create: (_) => ConvBloc()..add(FetchConversations(selectedModel)),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16.0,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon:
                            const Icon(Icons.close, color: Colors.transparent),
                      ),
                      const Spacer(),
                      const Text(
                        "Chat History",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: primaryColor),
                      ),
                    ],
                  ),
                  BlocBuilder<ConvBloc, ConvState>(
                    builder: (context, state) {
                      if (state is ConvLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ConvLoaded) {
                        return Expanded(
                          child: ListView.separated(
                            itemCount: state.convs.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final conversation = state.convs[index];
                              return ListTile(
                                title: Text(
                                  conversation.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    formatTimestamp(conversation.createdAt)),
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                  context.go(
                                    '/ai-chat',
                                    extra: {
                                      'model': selectedModel,
                                      'conversationId': conversation.id,
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        );
                      } else if (state is ConvError) {
                        return Center(child: Text(state.message));
                      }
                      return Container();
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

  void showPromptList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      builder: (context) {
        return BlocProvider(
          create: (_) => PromptBloc()
            ..add(const LoadPromptsEvent(
              isPublic: true,
              isFavorite: false,
              limit: 20,
              offset: 0,
            )),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 16.0,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon:
                            const Icon(Icons.close, color: Colors.transparent),
                      ),
                      const Spacer(),
                      const Text(
                        "Prompts",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: primaryColor),
                      ),
                    ],
                  ),
                  BlocBuilder<PromptBloc, PromptState>(
                    builder: (context, state) {
                      if (state is PromptLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is PromptLoaded) {
                        return Expanded(
                          child: ListView.separated(
                            itemCount: state.prompts.length,
                            separatorBuilder: (_, __) => const Divider(),
                            itemBuilder: (context, index) {
                              final prompt = state.prompts[index];
                              return ListTile(
                                title: Text(
                                  prompt.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(prompt.content),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  showPromptDialog(context, prompt);
                                },
                              );
                            },
                          ),
                        );
                      } else if (state is PromptError) {
                        return Center(child: Text(state.error));
                      }
                      return Container();
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
        Row(
          children: [
            AIModelDropdown(
              selectedModel: selectedModel,
              onModelSelected: updateModel,
            ),
            const Spacer(),
            IconButton(
              onPressed: () => showConversationHistory(context),
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
                    hintText: "Ask me anything or press '/' for prompts ...",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => {
                    if (value == '/') {showPromptList(context)}
                  },
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
        footer(context, widget.remainingTokens),
      ],
    );
  }
}
