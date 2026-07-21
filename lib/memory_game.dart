import 'package:flutter/material.dart';
import 'package:todo_app/flip_card_3d.dart';
import 'dart:math';

class MemoryCard {
  final int id;
  final int number;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.number,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<MemoryCard> cards = [];
  bool isProcessing = false;
  MemoryCard? firstSelectedCard;
  
  int attempts = 0;
  int? bestScore;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    attempts = 0;
    // Usaremos un grid de 3 columnas x 4 filas (12 cartas = 6 pares)
    List<int> numbers = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6];
    numbers.shuffle(Random());

    cards = List.generate(
      12,
      (index) => MemoryCard(id: index, number: numbers[index]),
    );
  }

  void _checkGameOver() {
    if (cards.every((c) => c.isMatched)) {
      // Game over!
      bool isNewBest = false;
      if (bestScore == null || attempts < bestScore!) {
        isNewBest = true;
        setState(() {
          bestScore = attempts;
        });
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: isNewBest 
              ? const Text('¡NUEVO RÉCORD!', textAlign: TextAlign.center, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 24))
              : const Text('¡Juego Completado!', textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isNewBest)
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 60),
                const SizedBox(height: 16),
                Text('Intentos: $attempts', style: const TextStyle(fontSize: 18)),
                if (!isNewBest && bestScore != null)
                  Text('Mejor récord: $bestScore', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                if (isNewBest)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text('¡Felicidades, mejoraste tu marca!', textAlign: TextAlign.center, style: TextStyle(color: Colors.green)),
                  ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      firstSelectedCard = null;
                      isProcessing = false;
                      _initializeGame();
                    });
                  },
                  child: const Text('Jugar de nuevo'),
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

      if (firstSelectedCard!.number == secondCard.number) {
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
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Memory Game'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Intentos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    Text('$attempts', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                  ],
                ),
                Column(
                  children: [
                    const Text('Mejor Récord', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    Text(bestScore == null ? '-' : '$bestScore', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columnas (grid de 3x4)
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.7, // Ajuste para que las cartas se vean verticales
                ),
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  return FlipCard3D(
                    isFlipped: cards[index].isFlipped,
                    isMatched: cards[index].isMatched,
                    number: cards[index].number,
                    onTap: () => _onCardTap(cards[index]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
