import 'dart:convert';

class BotChatMessage {
  final String role;
  final int createdAt;
  final String content;

  BotChatMessage(this.role, this.createdAt, this.content);

  factory BotChatMessage.fromJson(Map<String, dynamic> json) {
    String extractedContent = (json['content'] as List).isNotEmpty
        ? json['content'][0]['text']['value']
        : '';

    return BotChatMessage(
      json['role'],
      json['createdAt'],
      extractedContent,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'createdAt': createdAt,
      'content': content,
    };
  }
}
