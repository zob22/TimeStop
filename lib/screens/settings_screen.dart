import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timestop/widgets/background.dart';
import 'package:timestop/widgets/color_dropdown.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final background = context.watch<Background>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: background.selectedColor,
      ),
      backgroundColor: background.selectedColor,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              'Appearance',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            ColorDropdown(),
          ],
        ),
      ),
    );
  }
}
