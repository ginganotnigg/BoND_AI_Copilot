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
      emit(BotChatLoading(conv, ev.bot));
      try {
        await chatApi.askBot(conv, ev.bot);
      } catch (e) {
        emit(BotChatError(conv, "Fail To Send Message: $e"));
      }
    });
    //
    on<GetThreadEvent>((ev, emit) async {
      final conv = BotConv.from(state.conv);
      try {
        final updatedConv = await chatApi.getMessage(ev.bot);
        emit(BotChatResponseReceived(updatedConv,ev.bot));
      } catch (e) {
        emit(BotChatError(conv, "Fail To Get Thread: $e"));
      }
    });
    on<CreateThreadEvent>((ev, emit) async {
      final conv = BotConv.from(state.conv);
      emit(BotThreadLoading(conv, ev.bot));
      try {
        final bot = ev.bot;
        if (bot.thread.isNotEmpty) { //if thread is already there, no need to get new one
          emit(BotThreadLoaded(conv, bot));
          return;
        }
        final newThread = await chatApi.createNewThread(ev.bot);
        Bot updatedBot = Bot(bot.updatedAt, bot.id, bot.name, bot.aiId, bot.description, newThread);
        emit(BotThreadLoaded(conv, updatedBot));
      } catch (e) {
        emit(BotChatError(conv, "Fail To Create Thread: $e"));
      }
    });
  }
}
