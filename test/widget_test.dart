import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/home_screen.dart';
import 'package:memory_game/flip_card_3d.dart';
import 'package:memory_game/memory_game.dart';

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

  testWidgets('FlipCard3D back displays image with 0xFF80CBFA background', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: FlipCard3D(
                isFlipped: true,
                isMatched: false,
                iconString: 'assets/images/img_cards/1.png',
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );

    // Let the flip animation finish
    await tester.pumpAndSettle();

    // Verify back card image is rendered
    final cardImageFinder = find.byType(Image);
    expect(cardImageFinder, findsOneWidget);
    final cardImage = tester.widget<Image>(cardImageFinder);
    expect((cardImage.image as AssetImage).assetName, 'assets/images/img_cards/1.png');

    // Verify background color 0xFF80CBFA
    final containerFinder = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration as BoxDecoration).color == const Color(0xFF80CBFA),
    );
    expect(containerFinder, findsWidgets);
  });

  testWidgets('Ver consejos button navigates to ConsejosScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MemoryGameScreen(difficulty: GameDifficulty.easy),
      ),
    );

    // Verify button exists below the grid
    final consejosButton = find.text('Ver consejos');
    expect(consejosButton, findsOneWidget);

    // Tap the button
    await tester.tap(consejosButton);
    await tester.pumpAndSettle();

    // Verify we are on ConsejosScreen
    expect(find.text('CONSEJOS'), findsOneWidget);

    // Tap back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    // Back on MemoryGameScreen
    expect(find.text('Ver consejos'), findsOneWidget);
  });
}


