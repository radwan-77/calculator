import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_state.dart';
import 'package:intl/intl.dart';
import '../utils/storage_manager.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  final StorageManager storageManager = StorageManager();

  CalculatorCubit() : super(const CalculatorState()) {
    initializeCalculator();
  }

  Future<void> initializeCalculator() async {
    await storageManager.loadData(); // Load stored data
    final history = storageManager.getHistory(); // Get saved history
    emit(state.copyWith(history: history)); // Update state with history
  }

  void onButtonPressed(String text) {
    if (state.hasError) {
      clearError();
    }

    switch (text) {
      case 'CE':
        clear();
        break;
      case '±':
        toggleSign();
        break;
      case '.':
        addDecimal();
        break;
      case '=':
        calculate();
        break;
      case '+':
      case '-':
      case '*':
      case '/':
        setOperator(text);
        break;
      default:
        addDigit(text);
    }
  }

  void clear() {
    emit(
      state.copyWith(
        display: '0',
        number1: 0,
        operator: '',
        isNewNumber: true,
        hasError: false,
      ),
    );
  }

  void toggleSign() {
    if (state.display != '0') {
      final newDisplay =
          state.display.startsWith('-')
              ? state.display.substring(1)
              : '-${state.display}';
      emit(state.copyWith(display: newDisplay));
    }
  }

  void addDecimal() {
    if (!state.display.contains('.')) {
      emit(state.copyWith(display: '${state.display}.', isNewNumber: false));
    }
  }

  void addDigit(String digit) {
    String newDisplay;
    bool newIsNewNumber;

    if (state.isNewNumber) {
      newDisplay = digit;
      newIsNewNumber = false;
    } else {
      if (state.display == '0') {
        newDisplay = digit;
      } else {
        newDisplay = state.display + digit;
      }
      newIsNewNumber = false;
    }

    emit(state.copyWith(display: newDisplay, isNewNumber: newIsNewNumber));
  }

  void setOperator(String op) {
    if (state.operator.isNotEmpty && !state.isNewNumber) {
      calculate();
    }

    final number1 = double.parse(state.display.replaceAll(',', ''));
    emit(state.copyWith(number1: number1, operator: op, isNewNumber: true));
  }

  void calculate() {
    if (state.operator.isEmpty || state.isNewNumber) return;

    try {
      final number2 = double.parse(state.display.replaceAll(',', ''));
      double result = 0;

      switch (state.operator) {
        case '+':
          result = state.number1 + number2;
          break;
        case '-':
          result = state.number1 - number2;
          break;
        case '*':
          result = state.number1 * number2;
          break;
        case '/':
          if (number2 == 0) {
            emit(
              state.copyWith(
                display: 'Error: Division by zero',
                hasError: true,
              ),
            );
            return;
          }
          result = state.number1 / number2;
          break;
      }

      if (result.isInfinite || result.isNaN) {
        emit(state.copyWith(display: 'Error: Overflow', hasError: true));
        return;
      }

      final formattedResult = formatNumber(result);
      final displayResult = formatDisplayNumber(formattedResult);
      final expression =
          '${formatDisplayNumber(formatNumber(state.number1))} ${state.operator} ${formatDisplayNumber(formatNumber(number2))}';

      addToHistory(expression, displayResult);

      emit(
        state.copyWith(
          display: displayResult,
          number1: result,
          operator: '',
          isNewNumber: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(display: 'Error', hasError: true));
    }
  }

  String formatNumber(double number) {
    if (number % 1 == 0) {
      return number.toInt().toString();
    } else {
      String formatted = number.toStringAsFixed(8);
      while (formatted.endsWith('0') && formatted.contains('.')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
      if (formatted.endsWith('.')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
      return formatted;
    }
  }

  String formatDisplayNumber(String numberStr) {
    if (numberStr.contains('E') || numberStr.contains('e')) {
      return numberStr;
    }
    if (numberStr.contains('.')) {
      List<String> parts = numberStr.split('.');
      String integerPart = parts[0];
      String decimalPart = parts[1];
      String formattedInteger = NumberFormat(
        '#,##0',
      ).format(int.parse(integerPart));
      return '$formattedInteger.$decimalPart';
    } else {
      return NumberFormat('#,##0').format(int.parse(numberStr));
    }
  }

  void clearError() {
    emit(state.copyWith(display: '0', hasError: false, isNewNumber: true));
  }

  void addToHistory(String expression, String result) {
    final newHistory = List<Map<String, dynamic>>.from(state.history);
    newHistory.add({
      'expression': expression,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    emit(state.copyWith(history: newHistory));
    storageManager.saveHistory(newHistory);
  }

  void clearHistory() {
    emit(state.copyWith(history: []));
    storageManager.saveHistory([]);
  }

  void useHistoryResult(String result) {
    emit(state.copyWith(display: result, isNewNumber: true));
  }
}
