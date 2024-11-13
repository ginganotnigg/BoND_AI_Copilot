import 'package:bond/global.dart';
import 'package:bond/models/prompt.dart';
import 'package:flutter/material.dart';
import 'prompt_tile.dart';
import 'prompt_dialog.dart';

class PromptList extends StatefulWidget {
  final List<Prompt> prompts;

  const PromptList(this.prompts, {super.key});

  @override
  PromptListState createState() => PromptListState();
}

class PromptListState extends State<PromptList> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() => searchText = value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search...",
                    prefixIcon: const Icon(
                      Icons.search,
                      color: primaryColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: secondaryColor,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: primaryColor),
                onPressed: () => showPromptDialog(context, isEdit: false),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: widget.prompts
                .where((prompt) => prompt.title
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
                .map((prompt) => PromptTile(prompt))
                .toList(),
          ),
        ),
      ],
    );
  }
}

void showPromptManagementDialog(BuildContext context) {
  final prompts = {
    'Private': [
      Prompt(
        category: PromptCategory.business,
        content: 'Content for Prompt 1',
        description: 'Description for Prompt 1',
        isPublic: false,
        language: 'en',
        title: 'Prompt 1',
      ),
      Prompt(
        category: PromptCategory.career,
        content: 'Content for Prompt 2',
        description: 'Description for Prompt 2',
        isPublic: false,
        language: 'en',
        title: 'Prompt 2',
      ),
    ],
    'Public': [
      Prompt(
        category: PromptCategory.business,
        content: 'Content for Prompt 1',
        description: 'Description for Prompt 1',
        isPublic: true,
        language: 'en',
        title: 'Prompt 1',
      ),
      Prompt(
        category: PromptCategory.career,
        content: 'Content for Prompt 2',
        description: 'Description for Prompt 2',
        isPublic: true,
        language: 'en',
        title: 'Prompt 2',
      ),
    ],
    'Favourite': [
      Prompt(
        category: PromptCategory.business,
        content: 'Content for Prompt 1',
        description: 'Description for Prompt 1',
        isPublic: true,
        language: 'en',
        title: 'Prompt 1',
      ),
      Prompt(
        category: PromptCategory.career,
        content: 'Content for Prompt 2',
        description: 'Description for Prompt 2',
        isPublic: true,
        language: 'en',
        title: 'Prompt 2',
      ),
    ],
  };

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: DefaultTabController(
            length: 3,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Prompt Library",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arya',
                      ),
                    ),
                  ),
                  const TabBar(
                    indicatorColor: primaryColor,
                    labelColor: Colors.black,
                    tabs: [
                      Tab(text: 'Private'),
                      Tab(text: 'Public'),
                      Tab(text: 'Favourite'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: prompts.keys
                          .map((key) => PromptList(prompts[key]!))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
