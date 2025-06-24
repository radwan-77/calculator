import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_midterm/cubit/calculator_cubit.dart';
import 'package:for_midterm/cubit/calculator_state.dart';
import 'package:for_midterm/widgets/calculator_display.dart';
import 'package:for_midterm/widgets/calculator_keypad.dart';
import 'package:for_midterm/widgets/history_sheet.dart';

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Calculator'),
        actions: [
          IconButton(
            onPressed: () => showHistory(context),
            icon: const Icon(Icons.history),
            tooltip: 'History',
          ),
        ],
      ),
      body: BlocBuilder<CalculatorCubit, CalculatorState>(
        builder: (context, state) {
          return Column(
            children: [
              CalculatorDisplay(display: state.display),
              const SizedBox(height: 1),
              Expanded(
                child: CalculatorKeypad(
                  onButtonPressed: (text) {
                    context.read<CalculatorCubit>().onButtonPressed(text);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void showHistory(BuildContext context) {
    final calculatorCubit = context.read<CalculatorCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (modalContext) => BlocProvider.value(
            value: calculatorCubit,
            child: BlocBuilder<CalculatorCubit, CalculatorState>(
              builder: (context, state) {
                return HistorySheet(
                  history: state.history,
                  onClearHistory: () {
                    context.read<CalculatorCubit>().clearHistory();
                    Navigator.pop(context);
                  },
                  onUseResult: (result) {
                    context.read<CalculatorCubit>().useHistoryResult(result);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
    );
  }
}
