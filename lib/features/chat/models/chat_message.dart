class ChatMessage {
  final String aiModel;
  final String content;
  List<String>? files;

  ChatMessage({required this.content, required this.aiModel, this.files});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      aiModel: json['assistant'],
      content: json['content'],
      files: json['files'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'assistant': aiModel,
      'content': content,
      'files': files,
    };
  }
}
