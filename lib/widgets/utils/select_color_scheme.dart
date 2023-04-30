import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectColorScheme with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final List<Color> _availableColors = [
    Colors.grey.shade900,
    Colors.pink.shade900,
    Colors.green.shade900,
    Colors.blue.shade900,
    Colors.deepOrange.shade900,
    Colors.purple.shade900,
  ];

  Color _selectedColor = Colors.grey.shade900;

  SelectColorScheme() {
    getColorFromPrefs().then((color) {
      _selectedColor = color;
      notifyListeners();
    });
  }

  List<Color> get availableColors => _availableColors;
  Color get selectedColor => _selectedColor;

  Future<Color> getColorFromPrefs() async {
    final SharedPreferences prefs = await _prefs;
    final int? colorInt = prefs.getInt('colorScheme');
    if (colorInt != null) {
      return Color(colorInt);
    }
    return Colors.grey.shade900;
  }

  Future<void> setColor(Color color) async {
    final SharedPreferences prefs = await _prefs;
    _selectedColor = color;
    await prefs.setInt('colorScheme', _selectedColor.value);
    notifyListeners();
  }
}
