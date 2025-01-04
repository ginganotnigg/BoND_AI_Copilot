import 'package:bond/global.dart';
import 'package:bond/models/email/email_reply.dart';
import 'package:bond/services/ai_email_api.dart';
import 'package:bond/ui/ai-email/widget/chat_input.dart';
import 'package:bond/ui/ai-email/widget/chat_message.dart';
import 'package:bond/ui/ai-email/reply_draft_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmailReplyScreen extends StatefulWidget {
  const EmailReplyScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EmailReplyScreen createState() => _EmailReplyScreen();
}

class _EmailReplyScreen extends State<EmailReplyScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  late EmailReply lastEmailReply;

  void _onRetry(EmailReply emailReply) {
    _sendResponseEmail(emailReply, retry: true);
  }

  void _onAction(String action) async {
    _controller.text = action;
    _sendResponseEmail(lastEmailReply);
  }

  Future<void> _sendResponseEmail(EmailReply emailReply,
      {bool retry = false}) async {
    if (retry) {
      _messages.removeAt(_messages.length - 1);
    } else {
      setState(() {
        _messages.add(ChatMessage(
          message:
              _controller.text.isEmpty ? emailReply.email : _controller.text,
          isBot: false,
          onSendMessage: _onAction,
        ));
      });

      scrollToBottom();

      if (_controller.text.isNotEmpty) {
        emailReply.mainIdea = _controller.text;
        _controller.clear();
      }
    }

    setState(() {
      _messages.add(ChatMessage(
        message: "I'm currently working on your request. Please wait a moment.",
        isBot: true,
        onSendMessage: _onAction,
        isPreviousMessage: true,
      ));
    });

    try {
      final result = await AiEmailApi().responseEmail(emailReply);
      emailReply.email = result.email;
      lastEmailReply = emailReply;

      setState(() {
        _messages.removeAt(_messages.length - 1);
        _messages.add(ChatMessage(
          message: result.email,
          isBot: true,
          onSendMessage: _onAction,
          isPreviousMessage: true,
          onRetry: () => _onRetry(emailReply),
        ));
      });
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          message: e.toString(),
          isBot: true,
          onSendMessage: _onAction,
          isPreviousMessage: true,
          onRetry: () => _onRetry(emailReply),
        ));
      });
    }
    scrollToBottom();
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        maxScrollExtent + 200,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 200,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/');
            },
          ),
          title: const Text(
            'Response Email',
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _messages.isEmpty
                      ? ReplyDraftScreen(onSendMessage: _sendResponseEmail)
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: _messages.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ChatMessage(
                              message: _messages[index].message,
                              isBot: _messages[index].isBot,
                              onSendMessage: _messages[index].onSendMessage,
                              isPreviousMessage: index == _messages.length - 1,
                              onRetry: _messages[index].onRetry,
                            );
                          },
                        ),
                ),
                // chat input
                if (_messages.isNotEmpty)
                  ChatInput(
                    controller: _controller,
                    onSendMessage: () => _sendResponseEmail(lastEmailReply),
                    onClearMessages: () {
                      setState(() {
                        _messages.clear();
                      });
                    },
                  ),
              ],
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
