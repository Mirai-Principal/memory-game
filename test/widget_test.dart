import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game/home_screen.dart';
import 'package:memory_game/flip_card_3d.dart';
import 'package:memory_game/memory_game.dart';
import 'package:memory_game/consejos_screen.dart';

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

    // Verify new game header text and pair counter
    expect(find.text('Figuras encontradas: 0 de 6'), findsOneWidget);
    expect(find.text('Toca dos tarjetas y encuentra las iguales'), findsOneWidget);

    // Verify intentos and record are removed
    expect(find.text('INTENTOS'), findsNothing);
    expect(find.text('RÉCORD'), findsNothing);
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

    // Tap back button (ensure visible in scroll view first)
    await tester.ensureVisible(find.text('Volver al juego'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Volver al juego'));
    await tester.pumpAndSettle();

    // Back on MemoryGameScreen
    expect(find.text('Ver consejos'), findsOneWidget);
  });

  testWidgets('ConsejosScreen renders 6 ConsejoItemCards and Volver al juego button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ConsejosScreen(),
      ),
    );

    // Verify 6 ConsejoItemCards are built
    expect(find.byType(ConsejoItemCard), findsNWidgets(6));

    // Verify numbers 1 through 6 are present
    for (int i = 1; i <= 6; i++) {
      expect(find.text('$i'), findsOneWidget);
    }

    // Verify 'Volver al juego' button is present
    expect(find.text('Volver al juego'), findsOneWidget);
  });
}


