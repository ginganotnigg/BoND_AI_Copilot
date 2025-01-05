import 'package:bond/features/chat/bloc/chat_bloc/chat_event.dart';
import 'package:bond/features/chat/bloc/chat_bloc/chat_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bond/features/chat/ui/chat_screen.dart';
import 'package:bond/features/chat/bloc/chat_bloc/chat_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ChatScreen(
          initialSelectedModel: 'GPT-4o mini',
          title: 'Chat with AI',
          conversationId: null,
        ),
      ),
    ],
  );

  testWidgets('Chat feature test', (WidgetTester tester) async {
    final chatBloc = ChatBloc();

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        builder: (context, child) {
          return BlocProvider(
            create: (context) => chatBloc,
            child: BlocListener<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoading) {
                  // Verify loading state
                  expect(state, isA<ChatLoading>());
                } else if (state is ChatResponseReceived) {
                  // Verify response received
                  expect(state, isA<ChatResponseReceived>());
                } else if (state is TokenLoaded) {
                  // Verify tokens are updated
                  expect(state, isA<TokenLoaded>());
                  expect(state.tokens, greaterThan(0));
                }
              },
              child: Material(
                child: child!,
              ),
            ),
          );
        },
      ),
    );

    // Verify initial state
    expect(find.text('Chat with AI'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Enter a message and send
    await tester.enterText(find.byType(TextField), 'Hello, AI!');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    // Simulate response from AI
    chatBloc.add(SendMessageEvent('Hello, AI!', 'GPT-4o mini'));
    await tester.pumpAndSettle();
  });
}