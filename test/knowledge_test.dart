import 'package:flutter_test/flutter_test.dart';
import 'package:bond/features/knowledge_base/ui/bots_and_knowledge_screen.dart';
import 'package:bond/features/knowledge_base/bloc/knowledge_bloc.dart';
import 'package:bond/features/bot/bloc/bot_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const BotsAndKnowledgeScreen(),
      ),
    ],
  );

  testWidgets('Knowledge feature test', (WidgetTester tester) async {
    final knowledgeBloc = KnowledgeBloc();
    final botBloc = BotBloc();

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<KnowledgeBloc>(
                create: (context) => knowledgeBloc,
              ),
              BlocProvider<BotBloc>(
                create: (context) => botBloc,
              ),
            ],
            child: Material(
              child: child!,
            ),
          );
        },
      ),
    );

    // Verify initial state
    expect(find.text('Create Assistant'), findsOneWidget);
    expect(find.byType(TabBar), findsOneWidget);

    // Verify the Knowledge Base tab is displayed
    expect(find.text('Knowledge Base'), findsOneWidget);

    // // Switch to the Knowledge Base tab
    // await tester.tap(find.text('Knowledge Base'));
    // await tester.pumpAndSettle();

    // // Simulate loading knowledge
    // knowledgeBloc.add(FetchKnowledgeEvent());
    // await tester.pumpAndSettle();

    // // Verify loaded state
    // expect(knowledgeBloc.state, isA<KnowledgeLoaded>());

    // // Simulate adding knowledge
    // knowledgeBloc.add(AddKnowledgeEvent('Test Knowledge', 'This is a test knowledge'));
    // await tester.pumpAndSettle();

    // // Verify loaded state after adding knowledge
    // expect(knowledgeBloc.state, isA<KnowledgeLoaded>());

    // // Simulate editing knowledge
    // final knowledge = (knowledgeBloc.state as KnowledgeLoaded).knowledgeList.knowledgeList.first;
    // knowledgeBloc.add(EditKnowledgeEvent(knowledge.id, 'Updated Knowledge', 'Updated description'));
    // await tester.pumpAndSettle();

    // // Verify loaded state after editing knowledge
    // expect(knowledgeBloc.state, isA<KnowledgeLoaded>());

    // // Simulate deleting knowledge
    // knowledgeBloc.add(DeleteKnowledgeEvent(knowledge.id));
    // await tester.pumpAndSettle();

    // // Verify loaded state after deleting knowledge
    // expect(knowledgeBloc.state, isA<KnowledgeLoaded>());
  });
}
