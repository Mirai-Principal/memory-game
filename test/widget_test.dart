import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/home_screen.dart';

void main() {
  testWidgets('Memory Match smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Verify that our title is on the home screen.
    expect(find.text('MEMORY MATCH'), findsOneWidget);
    expect(find.text('FÁCIL (3x4)'), findsOneWidget);
  });
}
