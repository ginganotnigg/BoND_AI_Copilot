import 'package:bond/models/chat_message.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  final List<ChatMessage> chatHistory;
  final int remainingTokens;

  const ChatState(this.chatHistory, {this.remainingTokens = 0});

  @override
  List<Object> get props => [chatHistory, remainingTokens];
}

class ChatInitial extends ChatState {
  ChatInitial() : super([], remainingTokens: 100);
}

class ChatLoading extends ChatState {
  const ChatLoading(super.chatHistory, {super.remainingTokens});
}

class ChatResponseReceived extends ChatState {
  const ChatResponseReceived(
    super.chatHistory, {
    super.remainingTokens,
  });

  @override
  List<Object> get props => [chatHistory, remainingTokens];
}

class ChatError extends ChatState {
  final String error;

  const ChatError(super.chatHistory, this.error, {super.remainingTokens});

  @override
  List<Object> get props => [chatHistory, error, remainingTokens];
}
