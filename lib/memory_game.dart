import 'package:flutter/material.dart';
import 'package:memory_game/flip_card_3d.dart';
import 'package:memory_game/consejos_screen.dart';
import 'package:memory_game/mensaje.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

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
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => MemoryGameScreenState();
}

class MemoryGameScreenState extends State<MemoryGameScreen> {
  List<MemoryCard> cards = [];
  bool isProcessing = false;
  MemoryCard? firstSelectedCard;

  @visibleForTesting
  void checkGameOver() => _checkGameOver();

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  void _showWelcomeDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 24.0,
          ),
          child: Mensaje(
            title: '¡Activa tu memoria!',
            description:
                'Encuentra las figuras y descubre consejos de cuidado.',
            imageAsset: 'assets/images/empezar.png',
            buttonText: 'Empezar',
          ),
        );
      },
    );
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
        barrierDismissible: true,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 24.0,
            ),
            child: Mensaje(
              title: '¡Reto completado!',
              description:
                  'Encontraste las 6 figuras, comparte lo aprendido con tu familia.',
              imageAsset: 'assets/images/reto_completado.png',
              buttonText: 'Salir',
              onButtonPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          );
        },
      ).then((_) {
        if (mounted) {
          setState(() {
            firstSelectedCard = null;
            isProcessing = false;
            _initializeGame();
          });
        }
      });
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
                    _buildGameHeader(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                                childAspectRatio: 1.0,
                              ),
                          itemCount: cards.length,
                          itemBuilder: (context, index) {
                            return FractionallySizedBox(
                              widthFactor: 0.9,
                              heightFactor: 0.9,
                              child: FlipCard3D(
                                isFlipped: cards[index].isFlipped,
                                isMatched: cards[index].isMatched,
                                iconString: cards[index].iconString,
                                onTap: () => _onCardTap(cards[index]),
                              ),
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
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 100.0,
        bottom: 20.0,
      ),
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
