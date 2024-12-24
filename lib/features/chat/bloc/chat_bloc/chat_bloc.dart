import 'package:bond/features/chat/models/chat_message.dart';
import 'package:bond/features/chat/service/chat_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>((ev, emit) async {
      final convParams = state.convParams;
      convParams.modelName = ev.modelId;
      convParams.messages.add(ChatMessage(content: ev.message, aiModel: ""));
      emit(ChatLoading(convParams));
      final chatApi = ChatApi();
      try {
        String message = await chatApi.responseFromAI(convParams);
        convParams.messages
            .add(ChatMessage(content: message, aiModel: ev.modelId));
        emit(ChatResponseReceived(convParams));
      } catch (e) {
        emit(ChatError(convParams, e.toString()));
      }
    });
    on<GetConversationEvent>((ev, emit) async {
      final convParams = state.convParams;
      if (ev.convId.isEmpty) {
        return;
      }
      convParams.conversationId = ev.convId;
      emit(ChatLoading(convParams));
      final chatApi = ChatApi();
      try {
        convParams.messages =
            await chatApi.getConvMessages(ev.message, ev.convId);
        emit(ChatResponseReceived(convParams));
      } catch (e) {
        emit(ChatError(convParams, e.toString()));
      }
    });
    on<UpdateModelEvent>((ev, emit) async {
      final convParams = state.convParams;
      convParams.modelName = ev.selectedModel;
      emit(ChatResponseReceived(convParams));
    });
  }
}
