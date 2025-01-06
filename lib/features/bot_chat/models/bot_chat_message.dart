import 'package:bond/features/chat/models/ai_model.dart';

class BotChatMessage {
  final String role;
  final String content;
  final String createdAt;

  BotChatMessage(this.role, this.content, this.createdAt);

  factory BotChatMessage.fromJson(Map<String, dynamic> json) {
    return BotChatMessage(
      json['role'],
      json['content'],
      json['createdAt']
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'role': role,
      'content': content,
      'createdAt': createdAt
    };
    return json;
  }
}
