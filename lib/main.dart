import 'package:flutter/material.dart';
import 'package:timestop/widgets/utils/select_color_scheme.dart';
import 'package:timestop/widgets/utils/enable_notifications.dart';
import 'package:timestop/widgets/utils/select_time_format.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => SelectColorScheme()),
    ChangeNotifierProvider(create: (_) => SelectTimeFormat()),
    ChangeNotifierProvider(create: (_) => EnableNotifications()),
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
