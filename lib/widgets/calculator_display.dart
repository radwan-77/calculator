import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String display;

  const CalculatorDisplay({super.key, required this.display});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        textAlign: TextAlign.end,
        controller: TextEditingController(text: display),
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.yellow[50],
        ),
      ),
    );
  }
}
