import 'package:bond/features/chat/models/conv_params.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  final ConvParams convParams;

  const ChatState(this.convParams);

  @override
  List<Object> get props => [convParams];
}

class ChatInitial extends ChatState {
  ChatInitial() : super(ConvParams([], '', "GPT-4o mini"));
}

class ChatLoading extends ChatState {
  const ChatLoading(super.convParams);
}

class ChatResponseReceived extends ChatState {
  const ChatResponseReceived(super.convParams);
}

class ChatError extends ChatState {
  final String error;

  const ChatError(super.convParams, this.error);

  @override
  List<Object> get props => [convParams, error];
}

class TokenLoaded extends ChatState {
  final int tokens;

  const TokenLoaded(super.convParams, this.tokens);

  @override
  List<Object> get props => [tokens];
}
