import 'package:bond/features/chat/models/chat_message.dart';

class ConvParams {
  List<ChatMessage> messages;
  String? conversationId;
  String? modelName;
  ConvParams(this.messages,
    this.conversationId, this.modelName,
  );
}