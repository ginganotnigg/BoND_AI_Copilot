import 'package:bond/global.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class AIModel {
  final String name;
  final String imagePath;

  AIModel(this.name, this.imagePath);
}

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

  void showModelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(10.0),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.go('/assistant');
                    },
                    style: filled,
                    child: const Text("+ Create Assistant"),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: aiModels.map((AIModel model) {
                    return ListTile(
                      leading: SvgPicture.asset(
                        model.imagePath,
                        width: 40,
                        height: 40,
                      ),
                      title: Text(
                        model.name,
                        style: TextStyle(
                          fontWeight: widget.selectedModel == model.name
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          widget.onModelSelected(model.name);
                        });
                        Navigator.pop(context);
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModelDialog(context);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            SvgPicture.asset(
              aiModels
                  .firstWhere((model) => model.name == widget.selectedModel)
                  .imagePath,
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
