import 'package:flutter/material.dart';
import 'package:memory_game/flip_card_3d.dart';
import 'package:memory_game/consejos_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

enum GameDifficulty { easy, medium, hard }

class MemoryCard {
  final int id;
  final String iconString;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.iconString,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class MemoryGameScreen extends StatefulWidget {
  final GameDifficulty difficulty;
  const MemoryGameScreen({super.key, required this.difficulty});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<MemoryCard> cards = [];
  bool isProcessing = false;
  MemoryCard? firstSelectedCard;

  int get matchedPairs => cards.where((c) => c.isMatched).length ~/ 2;
  int get totalPairs => cards.length ~/ 2;

  void _playSound(String fileName) async {
    try {
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/$fileName'));
      player.onPlayerComplete.listen((event) {
        player.dispose();
      });
    } catch (e) {
      debugPrint("Error playing sound: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Lista de imágenes de cartas del juego
    const List<String> cardImages = [
      'assets/images/img_cards/1.png',
      'assets/images/img_cards/2.png',
      'assets/images/img_cards/3.png',
      'assets/images/img_cards/4.png',
      'assets/images/img_cards/5.png',
      'assets/images/img_cards/6.png',
    ];

    List<String> imagePool = List.from(cardImages);
    imagePool.shuffle(Random());

    // 3x4 = 12 cartas = 6 pares
    int pairCount = min(6, imagePool.length);

    List<String> selectedImages = imagePool.take(pairCount).toList();

    // Crear los pares de cartas
    List<String> gameImages = [...selectedImages, ...selectedImages];
    gameImages.shuffle(Random());

    cards = List.generate(
      pairCount * 2,
      (index) => MemoryCard(id: index, iconString: gameImages[index]),
    );
  }

  void _checkGameOver() {
    if (cards.every((c) => c.isMatched)) {
      _playSound('win.wav');

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2D2D44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              '¡JUEGO COMPLETADO!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF00FFCB),
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.emoji_events,
                  color: Color(0xFFFFD700),
                  size: 60,
                ),
                SizedBox(height: 16),
                Text(
                  '¡Felicidades! Has encontrado todas las figuras.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF007F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      firstSelectedCard = null;
                      isProcessing = false;
                      _initializeGame();
                    });
                  },
                  child: const Text(
                    'JUGAR DE NUEVO',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void _onCardTap(MemoryCard card) async {
    // Si estamos procesando un par, o si la carta ya está volteada o emparejada, no hacemos nada.
    if (isProcessing || card.isFlipped || card.isMatched) return;

    _playSound('flip.wav');

    setState(() {
      card.isFlipped = true;
    });

    if (firstSelectedCard == null) {
      firstSelectedCard = card;
    } else {
      isProcessing = true;
      MemoryCard secondCard = card;

      if (firstSelectedCard!.iconString == secondCard.iconString) {
        _playSound('match.wav');
        // Coinciden! Esperamos un momento para que el usuario vea el resultado y luego desaparecen.
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) {
          setState(() {
            firstSelectedCard!.isMatched = true;
            secondCard.isMatched = true;
            firstSelectedCard = null;
            isProcessing = false;
          });
          _checkGameOver();
        }
      } else {
        _playSound('error.wav');
        // No coinciden. Esperamos un poco y las regresamos a su estado original.
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          setState(() {
            firstSelectedCard!.isFlipped = false;
            secondCard.isFlipped = false;
            firstSelectedCard = null;
            isProcessing = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF005DAA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                firstSelectedCard = null;
                isProcessing = false;
                _initializeGame();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SizedBox.expand(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/fondo_juego.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox.shrink();
                  },
                ),
              ),
              SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    const SizedBox(height: 4),
                    _buildGameHeader(),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                widget.difficulty == GameDifficulty.easy
                                    ? 3
                                    : 4,
                            mainAxisSpacing: 14.0,
                            crossAxisSpacing: 14.0,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: cards.length,
                          itemBuilder: (context, index) {
                            return FlipCard3D(
                              isFlipped: cards[index].isFlipped,
                              isMatched: cards[index].isMatched,
                              iconString: cards[index].iconString,
                              onTap: () => _onCardTap(cards[index]),
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 36.0),
                      child: _buildVerConsejosButton(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Column(
        children: [
          // JUEGA Y APRENDE a cuidar a tu familia
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.5,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
              children: [
                TextSpan(text: 'JUEGA Y APRENDE '),
                TextSpan(
                  text: 'a cuidar a tu familia',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          // Línea rosada
          Container(
            width: 58,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFF06292),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          // Figuras encontradas: X de Y
          Text(
            'Figuras encontradas: $matchedPairs de $totalPairs',
            style: const TextStyle(
              color: Color(0xFF00B0FF),
              fontSize: 17.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          // Toca dos tarjetas y encuentra las iguales
          const Text(
            'Toca dos tarjetas y encuentra las iguales',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerConsejosButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFF97CA6), // Rosa claro superior
            Color(0xFFE23887), // Rosa magenta inferior
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE23887).withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ConsejosScreen()),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 46, vertical: 14),
            child: Text(
              'Ver consejos',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
