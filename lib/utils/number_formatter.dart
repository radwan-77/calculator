class NumberFormatter {
  static String formatNumber(double number) {
    if (number == number.toInt()) {
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

  static String formatDisplayNumber(String numberStr) {
    if (numberStr.contains('E') || numberStr.contains('e')) {
      return numberStr;
    }

    if (numberStr.contains('.')) {
      List<String> parts = numberStr.split('.');
      String integerPart = parts[0];
      String decimalPart = parts[1];

      String formattedInteger = '';
      for (int i = 0; i < integerPart.length; i++) {
        if (i > 0 && (integerPart.length - i) % 3 == 0) {
          formattedInteger += ',';
        }
        formattedInteger += integerPart[i];
      }

      return '$formattedInteger.$decimalPart';
    } else {
      String formatted = '';
      for (int i = 0; i < numberStr.length; i++) {
        if (i > 0 && (numberStr.length - i) % 3 == 0) {
          formatted += ',';
        }
        formatted += numberStr[i];
      }
      return formatted;
    }
  }
}
