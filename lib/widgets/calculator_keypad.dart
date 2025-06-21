import 'package:flutter/material.dart';
import 'calculator_button.dart';

class CalculatorKeypad extends StatelessWidget {
  final Function(String) onButtonPressed;

  const CalculatorKeypad({super.key, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildButtonRow(['7', '8', '9', '/']),
          _buildButtonRow(['4', '5', '6', '*']),
          _buildButtonRow(['1', '2', '3', '-']),
          _buildButtonRow(['0', '.', '±', '+']),
          _buildButtonRow(['C', 'CE', '=']),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          buttons.map((text) {
            Color? color;
            double? width;

            // Determine button color and width
            switch (text) {
              case '+':
              case '-':
              case '*':
              case '/':
                color = Colors.orange[400];
                break;
              case 'C':
              case 'CE':
                color = Colors.red[400];
                break;
              case '=':
                color = Colors.green[400];
                width = 150;
                break;
            }

            return CalculatorButton(
              text: text,
              color: color,
              width: width,
              onPressed: () => onButtonPressed(text),
            );
          }).toList(),
    );
  }
}
