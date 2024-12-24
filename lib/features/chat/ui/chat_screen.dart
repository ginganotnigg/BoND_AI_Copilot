import 'package:bond/shared/styles/styles.dart';
import 'package:bond/features/chat/ui/chat_input.dart';
import 'package:bond/shared/widget/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bond/features/chat/bloc/chat_bloc/chat_bloc.dart';
import 'package:bond/features/chat/bloc/chat_bloc/chat_event.dart';
import 'package:bond/features/chat/bloc/chat_bloc/chat_state.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';

class ChatScreen extends StatefulWidget {
  final String initialSelectedModel;
  final String? conversationId;

  const ChatScreen({
    super.key,
    required this.initialSelectedModel,
    this.conversationId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String selectedModel;

  @override
  void initState() {
    super.initState();
    selectedModel = widget.initialSelectedModel;
  }

  void onModelChanged(String newModel) {
    setState(() {
      selectedModel = newModel;
    });
  }

  Widget buildScaffold(BuildContext context) {
    int? remainingTokens;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat with AI"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading && state.convParams.messages.isEmpty) {
                    return loadingWidget();
                  }
                  // if (state is ChatResponseReceived &&
                  //     state.remaining != null) {
                  //   remainingTokens = state.remaining;
                  // }
                  return ListView.builder(
                    reverse: false, // Ensures messages start from the top
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: state.convParams.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.convParams.messages[index];
                      return Align(
                        alignment: message.aiModel == ""
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: message.aiModel == ""
                                ? primaryColor.withOpacity(0.5)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.aiModel != "")
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    message.aiModel,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              if (message.aiModel == "")
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

            // AIChatInput fixed at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: AIChatInput(
                remainingTokens: remainingTokens ?? 50,
                selectedModel: selectedModel,
                onModelChanged: onModelChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.conversationId == null) {
      return buildScaffold(context);
    }
    return BlocProvider(
        create: (_) => ChatBloc()
          ..add(GetConversationEvent(selectedModel, widget.conversationId ?? '')),
        child: buildScaffold(context));
  }
}
