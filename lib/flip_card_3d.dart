import 'package:flutter/material.dart';
import 'dart:math';

class FlipCard3D extends StatefulWidget {
  final bool isFlipped;
  final bool isMatched;
  final int number;
  final VoidCallback onTap;

  const FlipCard3D({
    super.key,
    required this.isFlipped,
    required this.isMatched,
    required this.number,
    required this.onTap,
  });

  @override
  State<FlipCard3D> createState() => _FlipCard3DState();
}

class _FlipCard3DState extends State<FlipCard3D> {
  bool _hasMatched = false;

  @override
  void didUpdateWidget(FlipCard3D oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isMatched && widget.isMatched) {
      _hasMatched = true; // Empieza la animación de estrellas
    }
    // Si se reinicia el juego y isMatched vuelve a false, reseteamos
    if (oldWidget.isMatched && !widget.isMatched) {
      _hasMatched = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isMatched) {
      if (_hasMatched) {
        return StarEffect(
          onComplete: () {
            if (mounted) {
              setState(() {
                _hasMatched = false;
              });
            }
          },
        );
      } else {
        // Carta desaparecida completamente
        return const SizedBox();
      }
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: widget.isFlipped ? 1 : 0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        builder: (context, double value, child) {
          bool isFront = value < 0.5;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspectiva 3D
              ..rotateY(value * pi),
            child: isFront
                ? _buildFrontCard()
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildBackCard(),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFrontCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.help_outline, color: Colors.white, size: 48),
    );
  }

  Widget _buildBackCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        '${widget.number}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 48,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// Widget de animación de estrellas
class StarEffect extends StatefulWidget {
  final VoidCallback onComplete;
  const StarEffect({super.key, required this.onComplete});

  @override
  State<StarEffect> createState() => _StarEffectState();
}

class _StarEffectState extends State<StarEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _controller.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: List.generate(6, (index) {
            final angle = (2 * pi / 6) * index;
            // Distancia de las estrellas al centro que va aumentando
            final radius = _controller.value * 50; 
            return Transform.translate(
              offset: Offset(cos(angle) * radius, sin(angle) * radius),
              child: Opacity(
                opacity: 1.0 - _controller.value,
                child: const Icon(Icons.star, color: Colors.amber, size: 36),
              ),
            );
          }),
        );
      },
    );
  }
}
