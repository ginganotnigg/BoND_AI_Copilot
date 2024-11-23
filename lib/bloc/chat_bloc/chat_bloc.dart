import 'package:bond/models/chat_message.dart';
import 'package:bond/services/chat_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>((ev, emit) async {
      final chatHistory = state.chatHistory;
      chatHistory.add(ChatMessage(ev.message, isUser: true));
      emit(ChatLoading(chatHistory));
      final chatApi = ChatApi();
      try {
        String message = await chatApi.responseFromAI(ev.message, ev.modelId);
        // String message = response['message'];
        // int remaining = response['remainingUsage'];
        chatHistory.add(ChatMessage(message, isUser: false));
        emit(ChatResponseReceived(chatHistory));
      } catch (e) {
        emit(ChatError(chatHistory, e.toString()));
      }
    });
    on<GetConversationEvent>((ev, emit) async {
      if (ev.convId.isEmpty) {
        return;
      }
      emit(const ChatLoading([]));
      final chatApi = ChatApi();
      try {
        List<ChatMessage> messages =
            await chatApi.getConvMessages(ev.message, ev.convId);
        emit(ChatResponseReceived(messages));
      } catch (e) {
        emit(ChatError(const [], e.toString()));
      }
    });
  }
}
