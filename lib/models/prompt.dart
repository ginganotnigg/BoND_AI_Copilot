enum PromptCategory {
  business,
  career,
  chatbot,
  coding,
  education,
  fun,
  marketing,
  other,
  productivity,
  seo,
  writing,
}

class Prompt {
  String? id;
  PromptCategory category;
  String content;
  String description;
  bool isPublic;
  bool? isFavorite;
  String language;
  String title;

  Prompt({
    this.id,
    required this.category,
    required this.content,
    required this.description,
    required this.isPublic,
    this.isFavorite,
    required this.language,
    required this.title,
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category.toString().split('.').last,
      'content': content,
      'description': description,
      'isPublic': isPublic,
      'language': language,
      'title': title,
    };
  }

  static Prompt fromJson(Map<String, dynamic> jsonDecode) {
    return Prompt(
      id: jsonDecode['_id'],
      category: jsonDecode['category'] != null
          ? PromptCategory.values.firstWhere(
              (e) => e.toString() == 'PromptCategory.' + jsonDecode['category'],
              orElse: () => PromptCategory.other,
            )
          : PromptCategory.other,
      content: jsonDecode['content'] ?? "",
      description: jsonDecode['description'] ?? "",
      isPublic: jsonDecode['isPublic'] ?? false,
      isFavorite: jsonDecode['isFavorite'] ?? false,
      language: jsonDecode['language'] ?? "en",
      title: jsonDecode['title'] ?? "",
    );
  }

  copyWith(
      {required String title,
      required String description,
      required String content,
      required bool isPublic,
      required PromptCategory category,
      required String language}) {}
}
