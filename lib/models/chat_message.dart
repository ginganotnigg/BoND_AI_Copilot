class ChatMessage {
  final String content;
  final bool isUser;

  ChatMessage(this.content, {required this.isUser});

  factory ChatMessage.fromJson(Map<String, dynamic> json, bool isUser) {
    return ChatMessage(
      json['content'] as String,
      isUser: isUser,
    );
  }
}