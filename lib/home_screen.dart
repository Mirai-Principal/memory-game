import 'package:flutter/material.dart';
import 'package:todo_app/memory_game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121E), // Mismo fondo oscuro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.psychology,
              size: 100,
              color: Color(0xFF00FFCB),
            ),
            const SizedBox(height: 20),
            const Text(
              'MEMORY MATCH',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 32,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Selecciona la dificultad',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 50),
            _buildDifficultyButton(
              context,
              'FÁCIL (3x4)',
              const Color(0xFF00FFCB),
              GameDifficulty.easy,
            ),
            const SizedBox(height: 20),
            _buildDifficultyButton(
              context,
              'MEDIO (4x4)',
              const Color(0xFFFFD700),
              GameDifficulty.medium,
            ),
            const SizedBox(height: 20),
            _buildDifficultyButton(
              context,
              'DIFÍCIL (4x5)',
              const Color(0xFFFF007F),
              GameDifficulty.hard,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(
    BuildContext context, 
    String text, 
    Color color, 
    GameDifficulty difficulty,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black, // Texto oscuro para mayor contraste en botones neón
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        minimumSize: const Size(250, 50),
        elevation: 5,
        shadowColor: color.withOpacity(0.5),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MemoryGameScreen(difficulty: difficulty),
          ),
        );
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
