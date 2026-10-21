import 'package:flutter/material.dart';
import 'package:todo_app/flip_card_3d.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  
  int attempts = 0;
  static Map<GameDifficulty, int> bestScores = {};
  
  int? get bestScore => bestScores[widget.difficulty];

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
    _loadBestScores();
    _initializeGame();
  }

  Future<void> _loadBestScores() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.containsKey('bestScore_easy')) {
        bestScores[GameDifficulty.easy] = prefs.getInt('bestScore_easy')!;
      }
      if (prefs.containsKey('bestScore_medium')) {
        bestScores[GameDifficulty.medium] = prefs.getInt('bestScore_medium')!;
      }
      if (prefs.containsKey('bestScore_hard')) {
        bestScores[GameDifficulty.hard] = prefs.getInt('bestScore_hard')!;
      }
    });
  }

  void _initializeGame() {
    attempts = 0;
    
    // Pool of available emojis
    List<String> emojiPool = [
      '🦊', '🐼', '🐸', '🦄', '🐲', '🐙',
      '🦁', '🐯', '🐵', '🐷', '🐧', '🦉',
      '🍎', '🍉', '🍌', '🍓', '🥑', '🍔',
      '🍕', '🚀', '🛸', '🏎️', '⚽', '🏀',
      '💎', '👻', '👽', '👾', '🤖', '🎃'
    ];
    
    // Shuffle the pool
    emojiPool.shuffle(Random());
    
    int pairCount = 6; // Default to Easy
    if (widget.difficulty == GameDifficulty.medium) pairCount = 8;
    if (widget.difficulty == GameDifficulty.hard) pairCount = 10;
    
    List<String> selectedEmojis = emojiPool.take(pairCount).toList();
    
    // Create the pairs
    List<String> gameEmojis = [...selectedEmojis, ...selectedEmojis];
    gameEmojis.shuffle(Random());

    cards = List.generate(
      pairCount * 2,
      (index) => MemoryCard(id: index, iconString: gameEmojis[index]),
    );
  }

  void _checkGameOver() {
    if (cards.every((c) => c.isMatched)) {
      _playSound('win.wav');
      // Game over!
      bool isNewBest = false;
      if (bestScore == null || attempts < bestScore!) {
        isNewBest = true;
        setState(() {
          bestScores[widget.difficulty] = attempts;
        });
        
        // Guardar el nuevo récord en SharedPreferences
        SharedPreferences.getInstance().then((prefs) {
          prefs.setInt('bestScore_${widget.difficulty.name}', attempts);
        });
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color(0xFF2D2D44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: isNewBest 
              ? const Text('¡NUEVO RÉCORD!', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF00FFCB), fontWeight: FontWeight.w900, fontSize: 24))
              : const Text('¡JUEGO COMPLETADO!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isNewBest)
                  const Icon(Icons.emoji_events, color: Color(0xFFFFD700), size: 60),
                const SizedBox(height: 16),
                Text('Intentos: $attempts', style: const TextStyle(fontSize: 18, color: Colors.white)),
                if (!isNewBest && bestScore != null)
                  Text('Mejor récord: $bestScore', style: const TextStyle(fontSize: 16, color: Colors.white54)),
                if (isNewBest)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('¡Felicidades, mejoraste tu marca!', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF00FFCB))),
                  ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF007F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      firstSelectedCard = null;
                      isProcessing = false;
                      _initializeGame();
                    });
                  },
                  child: const Text('JUGAR DE NUEVO', style: TextStyle(fontWeight: FontWeight.bold)),
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
      
      setState(() {
        attempts++;
      });

      if (firstSelectedCard!.iconString == secondCard.iconString) {
        _playSound('match.wav');
        // Coinciden! Esperamos un momento para que el usuario vea el número y luego desaparecen.
        await Future.delayed(const Duration(milliseconds: 600));
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
        await Future.delayed(const Duration(milliseconds: 1500));
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
        title: const Text(
          'MEMORY MATCH',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: Colors.black54,
                blurRadius: 4,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
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
          )
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Text('INTENTOS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1.2)),
                              Text('$attempts', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF00FFCB))),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              const Text('RÉCORD', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1.2)),
                              Text(bestScore == null ? '-' : '$bestScore', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFFFF007F))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.difficulty == GameDifficulty.easy ? 3 : 4, 
                          mainAxisSpacing: 16.0,
                          crossAxisSpacing: 16.0,
                          childAspectRatio: widget.difficulty == GameDifficulty.hard ? 0.8 : 0.7, 
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
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
