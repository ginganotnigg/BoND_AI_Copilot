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

class BotThreadLoading extends BotChatState {
  final Bot bot;
  const BotThreadLoading(super.conv, this.bot);

  @override
  List<Object> get props => [conv, bot];
}

class BotThreadLoaded extends BotChatState {
  final Bot bot;
  const BotThreadLoaded(super.conv, this.bot);

  @override
  List<Object> get props => [conv, bot];
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
