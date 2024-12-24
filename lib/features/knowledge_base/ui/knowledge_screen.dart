import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_bloc.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_event.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_state.dart';

class KnowledgeScreen extends StatelessWidget {
  const KnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => KnowledgeBloc()..add(FetchKnowledgeEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Knowledge Base'),
        ),
        body: Column(
          children: [
            customSearchBar(context),
            Expanded(child: knowledgeListView(context)),
            addKnowledgeButton(context),
          ],
        ),
      ),
    );
  }
}

Widget customSearchBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Search knowledge...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        suffixIcon: const Icon(Icons.search),
      ),
      onChanged: (query) {
        context.read<KnowledgeBloc>().add(SearchKnowledgeEvent(query));
      },
    ),
  );
}

Widget addKnowledgeButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(
      onPressed: () {
        // Navigate to add new knowledge screen
      },
      child: const Text('Add New Knowledge'),
    ),
  );
}

Widget knowledgeListView(BuildContext context) {
  return BlocBuilder<KnowledgeBloc, KnowledgeState>(
    builder: (context, state) {
      if (state is KnowledgeLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is KnowledgeLoaded) {
        return ListView.builder(
          itemCount: state.knowledgeList.knowledgeList.length,
          itemBuilder: (context, index) {
            final knowledge = state.knowledgeList.knowledgeList[index];
            return ListTile(
              title: Text(knowledge.title),
              subtitle: Text(knowledge.description),
              onTap: () {
                // Navigate to knowledge detail screen
              },
            );
          },
        );
      } else if (state is KnowledgeError) {
        return Center(child: Text(state.errorMessage));
      } else {
        return Container();
      }
    },
  );
}
