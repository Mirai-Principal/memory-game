import 'package:flutter/material.dart';
import 'package:todo_app/memory_game.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MemoryGameScreen(),
  ));
}

class CustomText extends StatelessWidget {
  final String text;
  final Color color;

  const CustomText({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: TextDirection.ltr,
      style: TextStyle(color: color),
    );
  }
}


