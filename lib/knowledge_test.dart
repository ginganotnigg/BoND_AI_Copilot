import 'package:flutter_test/flutter_test.dart';
import 'package:bond/features/knowledge_base/ui/knowledge_screen.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_bloc.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_event.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Knowledge feature test', (WidgetTester tester) async {
    final knowledgeBloc = KnowledgeBloc();

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => knowledgeBloc,
          child: const KnowledgeScreen(),
        ),
      ),
    );

    // Verify initial state
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Enter a search query
    await tester.enterText(find.byType(TextField), 'Test Knowledge');
    await tester.pump();

    // Verify search event
    expect(knowledgeBloc.state, isA<KnowledgeLoading>());

    // Simulate knowledge loaded
    knowledgeBloc.add(SearchKnowledgeEvent('Test Knowledge'));
    await tester.pump();

    // Verify knowledge loaded state
    expect(knowledgeBloc.state, isA<KnowledgeLoaded>());
  });
}
