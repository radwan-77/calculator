import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Import custom widgets
import 'widgets/calculator_display.dart';
import 'widgets/calculator_keypad.dart';
import 'widgets/history_sheet.dart';
import 'cubit/calculator_cubit.dart';
import 'cubit/calculator_state.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enhanced Calculator',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: BlocProvider(
        create: (context) => CalculatorCubit(),
        child: CalculatorApp(),
      ),
    );
  }
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Calculator'),
        actions: [
          IconButton(
            onPressed: () => _showHistory(context),
            icon: const Icon(Icons.history),
            tooltip: 'History',
          ),
        ],
      ),
      body: BlocBuilder<CalculatorCubit, CalculatorState>(
        builder: (context, state) {
          return Column(
            children: [
              CalculatorDisplay(
                display: state.display,
                hasError: state.hasError,
              ),
              const SizedBox(height: 20),
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

  void _showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => BlocBuilder<CalculatorCubit, CalculatorState>(
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
    );
  }
}
