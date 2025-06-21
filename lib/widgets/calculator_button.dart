import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 70,
      height: 70,
      margin: const EdgeInsets.all(4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.grey[300],
          foregroundColor: color != null ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
