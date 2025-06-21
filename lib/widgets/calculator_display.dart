import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String display;
  final bool hasError;

  const CalculatorDisplay({
    super.key,
    required this.display,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        readOnly: true,
        textAlign: TextAlign.end,
        controller: TextEditingController(text: display),
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: hasError ? Colors.red : Colors.black,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }
}
