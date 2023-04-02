import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timestop/widgets/time_switch.dart';
import 'package:timestop/widgets/utils/color_options.dart';
import 'package:timestop/widgets/color_dropdown.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final coloroption = context.watch<ColorOptions>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: coloroption.selectedColor,
      ),
      backgroundColor: coloroption.selectedColor,
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
            TimeSwitch(),
          ],
        ),
      ),
    );
  }
}
