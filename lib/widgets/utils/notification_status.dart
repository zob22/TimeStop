import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationStatus with ChangeNotifier {
  late final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late bool enableNotification = false;

  NotificationStatus() {
    _getNotificationStatusFromPrefs().then((status) {
      enableNotification = status ?? false;
      notifyListeners();
    });
  }

  Future<bool?> _getNotificationStatusFromPrefs() async {
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
