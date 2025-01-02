import 'package:bond/features/chat/models/ai_model.dart';

class ChatMessage {
  final String aiModel;
  final String role;
  final String content;
  List<String>? files;

  ChatMessage(
      {required this.content,
      required this.role,
      required this.aiModel,
      this.files});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      aiModel: json['assistant'],
      role: json['role'],
      content: json['content'],
      files: json['files'],
    );
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'assistant': {
        'id': getId(aiModel),
        'model': 'dify',
        'name': aiModel,
      },
      'role': role,
      'content': content,
    };
    if (files != null && files!.isNotEmpty) {
      json['files'] = files;
    }
    return json;
  }
}
