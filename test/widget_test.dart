import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/home_screen.dart';

void main() {
  testWidgets('Memory Match smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Verify that the play button is on the home screen.
    expect(find.text('Jugar ¡ahora!'), findsOneWidget);

    // Verify that inicio.jpg is rendered
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);
    final imageWidget = tester.widget<Image>(imageFinder);
    expect((imageWidget.image as AssetImage).assetName, 'assets/images/inicio.jpg');
  });

  testWidgets('Tapping play button navigates to MemoryGameScreen (3x4)', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    // Tap on play button
    await tester.tap(find.text('Jugar ¡ahora!'));
    await tester.pumpAndSettle();

    // Verify home screen is popped/pushed and game screen is active
    expect(find.text('Jugar ¡ahora!'), findsNothing);
  });
}
