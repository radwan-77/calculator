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
          buildButtonRow(['7', '8', '9', '/']),
          buildButtonRow(['4', '5', '6', '*']),
          buildButtonRow(['1', '2', '3', '-']),
          buildButtonRow(['0', '.', '±', '+']),
          buildButtonRow(['CE', '=']),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          buttons.map((text) {
            Color? color;
            double? width;
            int? flex;

            switch (text) {
              case '+':
              case '-':
              case '*':
              case '/':
                color = Colors.orange[400];
                break;
              case 'CE':
                color = Colors.red[400];
                break;
              case '=':
                color = Colors.green[400];
                flex = 3; // Wider button for equals
                break;
            }

            return Expanded(
              flex: flex ?? 1,
              child: CalculatorButton(
                text: text,
                color: color,
                width: width,
                onPressed: () => onButtonPressed(text),
              ),
            );
          }).toList(),
    );
  }
}
