import 'package:flutter_bloc/flutter_bloc.dart';
import 'calculator_state.dart';
import 'package:intl/intl.dart';
import '../utils/storage_manager.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  final StorageManager _storageManager = StorageManager();

  CalculatorCubit() : super(const CalculatorState()) {
    _initializeCalculator();
  }

  Future<void> _initializeCalculator() async {
    await _storageManager.loadData();
    final history = _storageManager.getHistory();
    emit(state.copyWith(history: history));
  }

  void onButtonPressed(String text) {
    if (state.hasError) {
      _clearError();
    }

    switch (text) {
      case 'C':
        _clear();
        break;
      case 'CE':
        _clearEntry();
        break;
      case '±':
        _toggleSign();
        break;
      case '.':
        _addDecimal();
        break;
      case '=':
        _calculate();
        break;
      case '+':
      case '-':
      case '*':
      case '/':
        _setOperator(text);
        break;
      default:
        _addDigit(text);
    }
  }

  void _clear() {
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

  void _clearEntry() {
    emit(state.copyWith(display: '0', isNewNumber: true));
  }

  void _toggleSign() {
    if (state.display != '0') {
      final newDisplay =
          state.display.startsWith('-')
              ? state.display.substring(1)
              : '-${state.display}';
      emit(state.copyWith(display: newDisplay));
    }
  }

  void _addDecimal() {
    if (!state.display.contains('.')) {
      emit(state.copyWith(display: '${state.display}.', isNewNumber: false));
    }
  }

  void _addDigit(String digit) {
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

  void _setOperator(String op) {
    if (state.operator.isNotEmpty && !state.isNewNumber) {
      _calculate();
    }

    final number1 = double.parse(state.display.replaceAll(',', ''));
    emit(state.copyWith(number1: number1, operator: op, isNewNumber: true));
  }

  void _calculate() {
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

      final formattedResult = _formatNumber(result);
      final displayResult = _formatDisplayNumber(formattedResult);
      final expression =
          '${_formatDisplayNumber(_formatNumber(state.number1))} ${state.operator} ${_formatDisplayNumber(_formatNumber(number2))}';

      _addToHistory(expression, displayResult);

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

  String _formatNumber(double number) {
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

  String _formatDisplayNumber(String numberStr) {
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

  void _clearError() {
    emit(state.copyWith(display: '0', hasError: false, isNewNumber: true));
  }

  void _addToHistory(String expression, String result) {
    final newHistory = List<Map<String, dynamic>>.from(state.history);
    newHistory.add({
      'expression': expression,
      'result': result,
      'timestamp': DateTime.now().toIso8601String(),
    });

    emit(state.copyWith(history: newHistory));
    _storageManager.saveHistory(newHistory);
  }

  void clearHistory() {
    emit(state.copyWith(history: []));
    _storageManager.saveHistory([]);
  }

  void useHistoryResult(String result) {
    emit(state.copyWith(display: result, isNewNumber: true));
  }
}
