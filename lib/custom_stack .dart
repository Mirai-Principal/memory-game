import 'package:flutter/material.dart';

class CustomStack extends StatelessWidget {
  const CustomStack({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: children,
    );
  }
}
