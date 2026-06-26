import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/chat/presentation/pages/chat_page.dart';

void main() {
  testWidgets('chat page renders the placeholder state', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ChatPage()));

    expect(find.text('Messaggi'), findsWidgets);
    expect(find.text('Coming soon.'), findsOneWidget);
    expect(find.byIcon(Icons.mark_chat_unread_outlined), findsOneWidget);
  });
}
