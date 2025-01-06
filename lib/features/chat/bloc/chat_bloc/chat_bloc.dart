import 'package:bond/features/chat/models/chat_message.dart';
import 'package:bond/features/chat/models/conv_params.dart';
import 'package:bond/features/chat/service/chat_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<GetTokensEvent>((ev, emit) async {
      final convParams = ConvParams.from(state.convParams);
      final chatApi = ChatApi();
      try {
        final remainingTokens = await chatApi.getTokens();
        emit(TokenLoaded(convParams, remainingTokens));
      } catch (e) {
        emit(ChatError(convParams, e.toString()));
      }
    });
    on<SendMessageEvent>((ev, emit) async {
      final convParams = ConvParams.from(state.convParams);
      final chatApi = ChatApi();
      convParams.modelName = ev.modelId;
      convParams.messages.add(
          ChatMessage(content: ev.message, aiModel: ev.modelId, role: 'user'));
      emit(ChatLoading(convParams));
      try {
        String message = await chatApi.responseFromAI(convParams);
        convParams.messages.add(
            ChatMessage(content: message, aiModel: ev.modelId, role: 'model'));
        emit(ChatResponseReceived(convParams));
      } catch (e) {
        emit(ChatError(convParams, e.toString()));
      }
      add(GetTokensEvent());
    });
    on<FirstSendMessageEvent>((ev, emit) async {
      final convParams = ConvParams([], null, ev.modelId);
      final chatApi = ChatApi();
      convParams.messages.add(
          ChatMessage(content: ev.message, aiModel: ev.modelId, role: 'user'));
      emit(ChatLoading(convParams));
      try {
        String message = await chatApi.responseFromAI(convParams);
        convParams.messages.add(
            ChatMessage(content: message, aiModel: ev.modelId, role: 'model'));
        String temp = await chatApi.getLatestConversations(ev.modelId);
        convParams.conversationId = temp;
        emit(ChatResponseReceived(convParams));
      } catch (e) {
        emit(ChatError(convParams, e.toString()));
      }
      add(GetTokensEvent());
    });
    on<GetConversationEvent>((ev, emit) async {
      final convParams = ConvParams.from(state.convParams);
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
      final convParams = ConvParams.from(state.convParams);
      convParams.modelName = ev.selectedModel;
      emit(ChatResponseReceived(convParams));
    });

    add(GetTokensEvent());
  }
}
