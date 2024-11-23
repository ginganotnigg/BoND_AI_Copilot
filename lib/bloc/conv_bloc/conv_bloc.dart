import 'package:bond/models/conversation.dart';
import 'package:bond/services/chat_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ConvEvent {}

class FetchConversations extends ConvEvent {
  final String model;

  FetchConversations(this.model);
}

abstract class ConvState {}

class ConvLoading extends ConvState {}

class ConvLoaded extends ConvState {
  final List<Conversation> convs;

  ConvLoaded(this.convs);
}

class ConvError extends ConvState {
  final String message;

  ConvError(this.message);
}

class ConvBloc extends Bloc<ConvEvent, ConvState> {
  ConvBloc() : super(ConvLoading()) {
    on<FetchConversations>((ev, emit) async {
      emit(ConvLoading());
      final chatApi = ChatApi();
      try {
        List<Conversation> convs = await chatApi.getConversations(ev.model);
        emit(ConvLoaded(convs));
      } catch (e) {
        emit(ConvError("Failed to fetch conversations"));
      }
    });
  }
}
