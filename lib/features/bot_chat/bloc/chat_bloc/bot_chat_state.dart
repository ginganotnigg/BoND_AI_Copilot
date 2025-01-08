import 'package:equatable/equatable.dart';
import '../../../bot/models/bot.dart';
import '../../models/bot_conv.dart';

abstract class BotChatState extends Equatable {
  final BotConv conv;

  const BotChatState(this.conv);

  @override
  List<Object> get props => [];
}

class BotChatInitial extends BotChatState {
  BotChatInitial() : super(BotConv([]));
}

class BotChatLoading extends BotChatState {
  final Bot bot;
  const BotChatLoading(super.conv, this.bot);

  @override
  List<Object> get props => [conv, bot];
}

class BotChatLoaded extends BotChatState {
  const BotChatLoaded(super.conv);
  @override
  List<Object> get props => [conv];
}

class BotChatResponseWaiting extends BotChatState {
  const BotChatResponseWaiting(super.conv);
  @override
  List<Object> get props => [conv];
}

class BotChatResponseReceived extends BotChatState {
  final Bot bot;
  const BotChatResponseReceived(super.conv, this.bot);
  @override
  List<Object> get props => [conv, bot];
}

class BotChatError extends BotChatState {
  final String error;

  const BotChatError(super.conv, this.error);

  @override
  List<Object> get props => [conv, error];
}
