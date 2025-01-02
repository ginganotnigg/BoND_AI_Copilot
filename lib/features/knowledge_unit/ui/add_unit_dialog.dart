import 'package:bond/features/knowledge_base/models/knowledge.dart';
import 'package:bond/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:bond/config/constant.dart';

class AddUnitDialog extends StatelessWidget {
  final Knowledge knowledge;

  const AddUnitDialog({super.key, required this.knowledge});

  String goToDetailAddUnitPage(String selectedOption) {
    switch (selectedOption) {
      case 'web':
        return '/unit-web';
      case 'confluence':
        return '/unit-confluence';
      case 'drive':
        return '/unit-drive';
      case 'slack':
        return '/unit-slack';
      default:
        return '/unit-file';
    }
  }

  Widget optionUnitItem({
    required String imagePath,
    required String title,
    required String subtitle,
    required String value,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            imagePath,
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    optionUnitItem(
                      imagePath: localFileImagePath,
                      title: "Local files",
                      subtitle: "Upload some files from your device...",
                      value: "local_file",
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(goToDetailAddUnitPage("local_file"),
                            extra: knowledge);
                      },
                    ),
                    optionUnitItem(
                      imagePath: webImagePath,
                      title: "Website",
                      subtitle: "Connect Browser...",
                      value: "web",
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(goToDetailAddUnitPage("web"),
                            extra: knowledge);
                      },
                    ),
                    optionUnitItem(
                      imagePath: confluenceImagePath,
                      title: "Confluence",
                      subtitle: "Connect Confluence...",
                      value: "confluence",
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(goToDetailAddUnitPage("confluence"),
                            extra: knowledge);
                      },
                    ),
                    optionUnitItem(
                      imagePath: driveImagePath,
                      title: "Drive",
                      subtitle: "Connect Google Drive...",
                      value: "drive",
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(goToDetailAddUnitPage("drive"),
                            extra: knowledge);
                      },
                    ),
                    optionUnitItem(
                      imagePath: slackImagePath,
                      title: "Slack",
                      subtitle: "Connect Slack...",
                      value: "slack",
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(goToDetailAddUnitPage("slack"),
                            extra: knowledge);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: outlined,
                    child: const Text("Cancel",
                        style: TextStyle(color: primaryColor)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
