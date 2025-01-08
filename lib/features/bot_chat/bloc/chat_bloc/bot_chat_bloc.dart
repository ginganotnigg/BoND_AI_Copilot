import 'package:bond/features/chat/models/conv_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bot/models/bot.dart';
import '../../models/bot_chat_message.dart';
import '../../models/bot_conv.dart';
import '../../service/bot_chat_api.dart';
import 'bot_chat_event.dart';
import 'bot_chat_state.dart';

class BotChatBloc extends Bloc<BotChatEvent, BotChatState> {

  final chatApi = BotChatApi();

  BotChatBloc() : super(BotChatInitial()) {
    //
    on<SendMessageEvent>((ev, emit) async {
      final conv = BotConv.from(state.conv);
      final message = ev.message;
      try {
        emit(BotChatResponseWaiting(conv));
        await chatApi.askBot(message, ev.bot);
        emit(BotChatResponseReceived(conv, ev.bot));
      } catch (e) {
        emit(BotChatError(conv, "Fail To Send Message: $e"));
      }
    });
    //
    on<GetThreadEvent>((ev, emit) async {
      final conv = BotConv.from(state.conv);
      try {
        emit(BotChatLoading(conv, ev.bot));
        final updatedConv = await chatApi.getMessage(ev.bot);
        emit(BotChatLoaded(updatedConv));
      } catch (e) {
        emit(BotChatError(conv, "Fail To Get Thread: $e"));
      }
    });
  }
}
