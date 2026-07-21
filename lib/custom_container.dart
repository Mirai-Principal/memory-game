import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // alto
      width: 100, // ancho
      margin: const EdgeInsets.all(8), // margen
      decoration: BoxDecoration(
        color: color, // color del fondo
        borderRadius: BorderRadius.circular(radius), // radio de las esquinas
      ),
    );
  }
}