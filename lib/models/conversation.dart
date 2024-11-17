class Conversation {
  final String? title;
  final String? id;
  final int? createdAt;

  Conversation({
    required this.title,
    required this.id,
    required this.createdAt,
  });

  // Factory method to create a Conversation instance from JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      title: json['title'] as String?,
      id: json['id'] as String?,
      createdAt: json['createdAt'] as int?,
    );
  }
}