import 'package:bond/models/chat_message.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  final List<ChatMessage> chatHistory;

  const ChatState(this.chatHistory);

  @override
  List<Object> get props => [chatHistory];
}

class ChatInitial extends ChatState {
  ChatInitial() : super([]);
}

class ChatLoading extends ChatState {
  const ChatLoading(super.chatHistory);
}

class ChatResponseReceived extends ChatState {
  const ChatResponseReceived(super.chatHistory);
}

class ChatError extends ChatState {
  final String error;

  const ChatError(super.chatHistory, this.error);

  @override
  List<Object> get props => [chatHistory, error];
}
