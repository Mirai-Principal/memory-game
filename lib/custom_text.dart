import 'package:flutter/material.dart';

class CustomTextConParametro extends StatelessWidget {
  // agregamos la propiedad con nombre y la palabra required
  // para que sea obligatoria
  const CustomTextConParametro({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, textDirection: TextDirection.ltr);
  }
}