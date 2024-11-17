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
