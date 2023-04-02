import 'package:flutter/material.dart';
import 'package:timestop/widgets/utils/color_options.dart';
import 'package:timestop/widgets/utils/time_format.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ColorOptions()),
    ChangeNotifierProvider(create: (_) => TimeFormat()),
  ], child: const MyApp()));
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
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
