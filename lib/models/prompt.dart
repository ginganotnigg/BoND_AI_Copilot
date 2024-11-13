import 'package:bond/global.dart';

class Prompt {
  PromptCategory category;
  String content;
  String description;
  bool isPublic;
  String language;
  String title;

  Prompt({
    required this.category,
    required this.content,
    required this.description,
    required this.isPublic,
    required this.language,
    required this.title,
  });
}
