import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorOptions with ChangeNotifier {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<Color> storedColor = _getColorFromPrefs();

  final List<Color> _colors = [
    Colors.grey.shade900,
    Colors.pink.shade900,
    Colors.green.shade900,
    Colors.blue.shade900,
    Colors.deepOrange.shade900,
    Colors.purple.shade900,
  ];
  Color _selectedColor = Colors.grey.shade900;

  ColorOptions() {
    storedColor.then((color) {
      _selectedColor = color;
      notifyListeners();
    });
  }

  List<Color> get colors => _colors;
  Color get selectedColor => _selectedColor;

  Future<Color> _getColorFromPrefs() async {
    final SharedPreferences prefs = await _prefs;
    final int? colorInt = prefs.getInt('_selectedColor');
    if (colorInt != null) {
      return Color(colorInt);
    }
    return Colors.grey.shade900;
  }

  Future<void> setColor(Color colorVal) async {
    final SharedPreferences prefs = await _prefs;
    _selectedColor = colorVal;
    await prefs.setInt('_selectedColor', _selectedColor.value);
    notifyListeners();
  }
}
