import 'package:equatable/equatable.dart';

class CalculatorState extends Equatable {
  final String display;
  final double number1;
  final String operator;
  final bool isNewNumber;
  final bool hasError;
  final List<Map<String, dynamic>> history;

  const CalculatorState({
    this.display = '0',
    this.number1 = 0,
    this.operator = '',
    this.isNewNumber = true,
    this.hasError = false,
    this.history = const [],
  });

  CalculatorState copyWith({
    String? display,
    double? number1,
    String? operator,
    bool? isNewNumber,
    bool? hasError,
    List<Map<String, dynamic>>? history,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      number1: number1 ?? this.number1,
      operator: operator ?? this.operator,
      isNewNumber: isNewNumber ?? this.isNewNumber,
      hasError: hasError ?? this.hasError,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [
    display,
    number1,
    operator,
    isNewNumber,
    hasError,
    history,
  ];
}
