import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectTimeFormat with ChangeNotifier {
  late final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late bool displayHours = false;

  SelectTimeFormat() {
    getDisplayHoursFromPrefs().then((status) {
      displayHours = status ?? false;
      notifyListeners();
    });
  }

  Future<bool?> getDisplayHoursFromPrefs() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('displayHours');
  }

  Future<void> setDisplayHours(bool status) async {
    final SharedPreferences prefs = await _prefs;
    displayHours = status;
    await prefs.setBool('displayHours', displayHours);
    notifyListeners();
  }
}
