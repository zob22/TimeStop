import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TimeStop',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey, // Set primarySwatch to blueGrey
        brightness: Brightness.dark, // Set the brightness to dark
      ),
      home: const MyHomePage(title: 'TimeStop'),
    );
  }
}
