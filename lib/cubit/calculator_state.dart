import 'package:equatable/equatable.dart';

class CalculatorState extends Equatable {
  final String display;
  final double number1;
  final double number2;
  final String operator;
  final bool isNewNumber;
  final bool hasError;
  final List<Map<String, dynamic>> history;
  final bool shouldSaveToHistory;
  final String? lastExpression;
  final String? lastResult;

  const CalculatorState({
    this.display = '0',
    this.number1 = 0,
    this.number2 = 0,
    this.operator = '',
    this.isNewNumber = true,
    this.hasError = false,
    this.history = const [],
    this.shouldSaveToHistory = false,
    this.lastExpression,
    this.lastResult,
  });

  CalculatorState copyWith({
    String? display,
    double? number1,
    double? number2,
    String? operator,
    bool? isNewNumber,
    bool? hasError,
    List<Map<String, dynamic>>? history,
    bool? shouldSaveToHistory,
    String? lastExpression,
    String? lastResult,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      number1: number1 ?? this.number1,
      number2: number2 ?? this.number2,
      operator: operator ?? this.operator,
      isNewNumber: isNewNumber ?? this.isNewNumber,
      hasError: hasError ?? this.hasError,
      history: history ?? this.history,
      shouldSaveToHistory: shouldSaveToHistory ?? this.shouldSaveToHistory,
      lastExpression: lastExpression ?? this.lastExpression,
      lastResult: lastResult ?? this.lastResult,
    );
  }

  @override
  List<Object?> get props => [
    display,
    number1,
    number2,
    operator,
    isNewNumber,
    hasError,
    history,
    shouldSaveToHistory,
    lastExpression,
    lastResult,
  ];
}
