import 'dart:io';

import 'package:bond/global.dart';
import 'package:bond/ui/chat/ai_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

Widget aiModelDialog(
    BuildContext context, List<AIModel> aiModels, AIModelDropdown widget) {
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
                  widget.onModelSelected(model.name);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          )
        ],
      ),
    ),
  );
}

Widget loadingWidget() {
  return Center(
    child: Platform.isAndroid
        ? const CircularProgressIndicator()
        : const CupertinoActivityIndicator(),
  );
}

Widget featureList(BuildContext context) {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListTile(
        leading: Icon(Icons.integration_instructions),
        title: Text("Multi-Source Knowledge Integration 📚"),
        subtitle: Text(
            "Seamlessly integrate various types of knowledge from multiple data sources such as Websites, Google Drive, GitHub, GitLab, Notion, and more."),
      ),
      ListTile(
        leading: Icon(Icons.developer_mode),
        title: Text("Comprehensive SDK 🛠️"),
        subtitle: Text(
            "Our SDK provides the tools and resources needed to integrate chatbots into your own applications with ease."),
      ),
      // Add more features in the list
    ],
  );
}