import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimeFormat with ChangeNotifier {
  late final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late bool displayHours = false;

  TimeFormat() {
    _getTimeFromPrefs().then((time) {
      displayHours = time ?? false;
      notifyListeners();
    });
  }

  Future<bool?> _getTimeFromPrefs() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('displayHours');
  }

  Future<void> setTime(bool timeVal) async {
    final SharedPreferences prefs = await _prefs;
    displayHours = timeVal;
    await prefs.setBool('displayHours', displayHours);
    notifyListeners();
  }
}
