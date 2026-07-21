import 'package:flutter/material.dart';

class CustomColumn extends StatelessWidget {
  const CustomColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      // es como se van a acomodar a los hijos del Column
      // en el eje de arriba - abajo.
      mainAxisAlignment: mainAxisAlignment,
      textDirection: TextDirection.ltr,
      children: children,
    );
  }
}