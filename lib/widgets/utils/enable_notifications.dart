import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnableNotifications with ChangeNotifier {
  late final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late bool enableNotification = false;

  EnableNotifications() {
    getNotificationStatusFromPrefs().then((status) {
      enableNotification = status ?? false;
      notifyListeners();
    });
  }

  Future<bool?> getNotificationStatusFromPrefs() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('enableNotification');
  }

  Future<void> setNotificationStatus(bool status) async {
    final SharedPreferences prefs = await _prefs;
    enableNotification = status;
    await prefs.setBool('enableNotification', enableNotification);
    notifyListeners();
  }
}
