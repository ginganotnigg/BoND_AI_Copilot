import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;
  final String type;

  SendMessage({required this.message, required this.type});

  @override
  List<Object?> get props => [message, type];
}

class ReceiveAIResponse extends ChatEvent {
  final String aiMessage;

  ReceiveAIResponse({required this.aiMessage});

  @override
  List<Object?> get props => [aiMessage];
}

class InitializeChat extends ChatEvent {
  final String? initialMessage;

  InitializeChat({this.initialMessage});

  @override
  List<Object?> get props => [initialMessage];
}
