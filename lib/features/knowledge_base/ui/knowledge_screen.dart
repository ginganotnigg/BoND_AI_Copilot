import 'package:bond/features/knowledge_base/bloc/knowledge_bloc.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_event.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_state.dart';
import 'package:bond/features/knowledge_base/ui/add_knowledge_dialog.dart';
import 'package:bond/shared/styles/styles.dart';
import 'package:bond/shared/widget/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    return customSearchBar(context, (query) {
                      context
                          .read<KnowledgeBloc>()
                          .add(SearchKnowledgeEvent(query));
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: primaryColor),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AddKnowledgeDialog(
                      onSave: (title, description) {
                        // Use the parent context to access the KnowledgeBloc
                        context
                            .read<KnowledgeBloc>()
                            .add(AddKnowledgeEvent(title, description));
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<KnowledgeBloc, KnowledgeState>(
            builder: (context, state) {
              if (state is KnowledgeLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is KnowledgeError) {
                return Center(
                  child: Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else if (state is KnowledgeLoaded) {
                final knowledgeList = state.knowledgeList.knowledgeList;

                if (knowledgeList.isEmpty) {
                  return const Center(
                      child: Text('No knowledge entries found.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: knowledgeList.length,
                  itemBuilder: (context, index) {
                    final knowledge = knowledgeList[index];
                    return Card(
                      child: ListTile(
                        title: Text(knowledge.title,
                            style: const TextStyle(color: primaryColor)),
                        subtitle: Text(
                          knowledge.description,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 10),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.info,
                                  color: primaryColor, size: 20),
                              onPressed: () {
                                context.go('/unit', extra: knowledge);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: primaryColor, size: 20),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) =>
                                      AddKnowledgeDialog(
                                    initialTitle: knowledge.title,
                                    initialDescription: knowledge.description,
                                    onSave: (title, description) {
                                      context.read<KnowledgeBloc>().add(
                                            EditKnowledgeEvent(
                                              knowledge.id,
                                              title,
                                              description,
                                            ),
                                          );
                                    },
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: primaryColor, size: 20),
                              onPressed: () {
                                context.read<KnowledgeBloc>().add(
                                      DeleteKnowledgeEvent(knowledge.id),
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Unexpected state.'));
              }
            },
          ),
        ),
      ],
    );
  }
}
