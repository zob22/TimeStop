import 'package:flutter/material.dart';

class Background with ChangeNotifier {
  final List<Color> _colors = [
    Colors.grey.shade900,
    Colors.pink.shade900,
    Colors.green.shade900,
    Colors.blue.shade900,
    Colors.deepOrange.shade900,
    Colors.purple.shade900,
  ];
  Color _selectedColor = Colors.grey.shade900;

  List<Color> get colors => _colors;
  Color get selectedColor => _selectedColor;

  void setColor(Color value) {
    _selectedColor = value;
    notifyListeners();
  }
}