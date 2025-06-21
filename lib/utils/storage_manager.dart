import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageManager {
  late SharedPreferences prefs;
  List<Map<String, dynamic>> history = [];

  Future<void> loadData() async {
    prefs = await SharedPreferences.getInstance();

    String? historyJson = prefs.getString('calculatorhistory');
    if (historyJson != null) {
      List<dynamic> historyList = json.decode(historyJson);
      history =
          historyList.map((item) => Map<String, dynamic>.from(item)).toList();
    }
  }

  Future<void> saveHistory(List<Map<String, dynamic>> history) async {
    if (history.length > 50) {
      history = history.sublist(history.length - 50);
    }
    await prefs.setString('calculatorhistory', json.encode(history));
  }

  List<Map<String, dynamic>> getHistory() => history;
}
