import 'package:bond/features/chat/models/ai_model.dart';
import 'package:bond/shared/widget/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AIModelDropdown extends StatefulWidget {
  final String selectedModel;
  final ValueChanged<String> onModelSelected;
  const AIModelDropdown(
      {super.key, required this.selectedModel, required this.onModelSelected});
  @override
  State<AIModelDropdown> createState() => _AIModelDropdownState();
}

class _AIModelDropdownState extends State<AIModelDropdown> {
  final List<AIModel> aiModels = [
    AIModel("GPT-4o mini", "lib/assets/images/models/gpt4o_mini.svg"),
    AIModel("GPT-4o", "lib/assets/images/models/gpt4o.svg"),
    AIModel("Gemini 1.5 Flash", "lib/assets/images/models/gemini15_flash.svg"),
    AIModel("Gemini 1.5 Pro", "lib/assets/images/models/gemini15_pro.svg"),
    AIModel("Claude 3 Haiku", "lib/assets/images/models/claude3_haiku.svg"),
    AIModel(
        "Claude 3.5 Sonnet", "lib/assets/images/models/claude35_sonnet.svg"),
  ];

  void showModelDialog(BuildContext context, List<AIModel> aiModels) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return aiModelDialog(context, aiModels, widget);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<AIModel> aiModels = [
      AIModel("GPT-4o mini", "lib/assets/images/models/gpt4o_mini.svg"),
      AIModel("GPT-4o", "lib/assets/images/models/gpt4o.svg"),
      AIModel(
          "Gemini 1.5 Flash", "lib/assets/images/models/gemini15_flash.svg"),
      AIModel("Gemini 1.5 Pro", "lib/assets/images/models/gemini15_pro.svg"),
      AIModel("Claude 3 Haiku", "lib/assets/images/models/claude3_haiku.svg"),
      AIModel(
          "Claude 3.5 Sonnet", "lib/assets/images/models/claude35_sonnet.svg"),
    ];

    return GestureDetector(
      onTap: () {
        showModelDialog(context, aiModels);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            SvgPicture.asset(
              aiModels
                  .firstWhere((model) => model.name == widget.selectedModel)
                  .imagePath!,
              width: 24,
              height: 24,
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
