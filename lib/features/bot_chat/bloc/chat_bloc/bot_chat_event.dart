import 'package:equatable/equatable.dart';

import '../../../bot/models/bot.dart';

abstract class BotChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends BotChatEvent {
  final String message;
  final Bot bot;

  SendMessageEvent(this.message, this.bot);

  @override
  List<Object> get props => [message];
}

class GetThreadEvent extends BotChatEvent {
  final Bot bot;

  GetThreadEvent(this.bot);

  @override
  List<Object> get props => [bot];
}

class CreateThreadEvent extends BotChatEvent {
  final Bot bot;

  CreateThreadEvent(this.bot);

  @override
  List<Object> get props => [bot];
}

