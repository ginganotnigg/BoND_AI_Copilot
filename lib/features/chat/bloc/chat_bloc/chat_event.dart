import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String message;
  final String modelId;

  SendMessageEvent(this.message, this.modelId);

  @override
  List<Object> get props => [message, modelId];
}

class FirstSendMessageEvent extends ChatEvent {
  final String message;
  final String modelId;

  FirstSendMessageEvent(this.message, this.modelId);

  @override
  List<Object> get props => [message, modelId];
}

class GetConversationEvent extends ChatEvent {
  final String message;
  final String convId;

  GetConversationEvent(this.message, this.convId);

  @override
  List<Object> get props => [message, convId];
}

class UpdateModelEvent extends ChatEvent {
  final String selectedModel;

  UpdateModelEvent(this.selectedModel);

  @override
  List<Object> get props => [selectedModel];
}

class FetchConversationsEvent extends ChatEvent {
  final String selectedModel;

  FetchConversationsEvent(this.selectedModel);
}
