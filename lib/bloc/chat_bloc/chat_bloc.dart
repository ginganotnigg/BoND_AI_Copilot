import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatState()) {
    on<InitializeChat>(_onInitializeChat);
    on<SendMessage>(_onSendMessage);
    on<ReceiveAIResponse>(_onReceiveAIResponse);
  }

  void _onInitializeChat(InitializeChat event, Emitter<ChatState> emit) {
    if (event.initialMessage != null) {
      emit(state.copyWith(messages: [
        ...state.messages,
        {'message': event.initialMessage!, 'type': 'user'},
      ]));
      add(ReceiveAIResponse(aiMessage: "This is a simulated AI response."));
    }
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
    emit(state.copyWith(
      messages: [...state.messages, {'message': event.message, 'type': event.type}],
      isLoading: true,
    ));

    // Simulate AI response delay
    await Future.delayed(const Duration(seconds: 1));

    // Simulated AI response
    add(ReceiveAIResponse(aiMessage: "This is a simulated AI response."));
  }

  void _onReceiveAIResponse(ReceiveAIResponse event, Emitter<ChatState> emit) {
    emit(state.copyWith(
      messages: [...state.messages, {'message': event.aiMessage, 'type': 'ai'}],
      isLoading: false,
    ));
  }
}