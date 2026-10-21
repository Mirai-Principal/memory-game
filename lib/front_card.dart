import 'package:flutter/material.dart';

/// Widget que replica el diseo de la carta frontal (front_card.png)
/// en formato cuadrado, con acabado estilo hielo, bordes redondeados, degradado
/// celeste y el smbolo de interrogacin redondeado extra bold al centro.
class FrontCard extends StatelessWidget {
  const FrontCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          // Borde exterior blanco/celeste brillante tipo halo
          border: Border.all(color: const Color(0xFFE2F4FE), width: 2.0),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF002A50).withValues(alpha: 0.35),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            // Borde interior azul marino oscuro
            border: Border.all(color: const Color(0xFF0C5073), width: 2.2),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFBCE6FD), // Celeste hielo superior
                Color(0xFF80CBFA), // Azul cielo medio
                Color(0xFF50ABF2), // Azul cerleo
                Color(0xFF3396E7), // Azul vibrante inferior
              ],
              stops: [0.0, 0.35, 0.70, 1.0],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Brillo superior que acenta el efecto de hielo / cristal
              Positioned(
                top: 3,
                left: 8,
                right: 8,
                height: 16,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.45),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Signo de interrogacin extra bold usando trazo grueso + relleno
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '?',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w400,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 9.0
                          ..strokeCap = StrokeCap.round
                          ..strokeJoin = StrokeJoin.round
                          ..color = const Color(
                            0xFF2384D3,
                          ).withValues(alpha: 0.85),
                      ),
                    ),
                    Text(
                      '?',
                      style: TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF2384D3).withValues(alpha: 0.85),
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
