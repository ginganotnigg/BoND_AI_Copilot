class AIModel {
  final String name;
  final String imagePath;

  AIModel(this.name, this.imagePath);
}

String getId(String name) {
    switch (name) {
      case 'Claude 3 Haiku':
        return 'claude3-haiku-20240307';
      case 'Claude 3.5 Sonnet':
        return 'claude3-sonnet-20240229';
      case 'Gemini 1.5 Flash':
        return 'gemini-1-5-flash-latest';
      case 'Gemini 1.5 Pro':
        return 'gemini-1-5-pro-latest';
      case 'GPT-4o':
        return 'gpt-4o';
      case 'GPT-4o mini':
        return 'gpt-4o-mini';
      default:
        return 'gpt-4o-mini';
    }
  }