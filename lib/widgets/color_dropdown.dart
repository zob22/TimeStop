import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timestop/widgets/utils/color_options.dart';

class ColorDropdown extends StatefulWidget {
  const ColorDropdown({Key? key}) : super(key: key);
  @override
  State<ColorDropdown> createState() => _ColorDropdownState();
}

class _ColorDropdownState extends State<ColorDropdown> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ColorOptions>(
      builder: (context, coloroption, child) {
        //Create a list of DropdownMenuItem widgets based on the colors defined in the colorscheme object.
        final colorItems = [
          for (final colorPreview in coloroption.colors)
            DropdownMenuItem(
              value: colorPreview,
              child: Container(
                width: 120,
                height: 20,
                decoration: BoxDecoration(
                  color: colorPreview,
                  border: Border.all(
                    color: Colors.grey.shade500,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
        ];

        //Displays the Color Scheme setting
        return Row(
          children: [
            const Text('Color scheme'),
            const Spacer(),
            DropdownButton(
              dropdownColor: coloroption.selectedColor.withOpacity(0.8),
              focusColor: coloroption.selectedColor,
              value: coloroption.selectedColor,
              items: colorItems,
              onChanged: (value) {
                coloroption.setColor(value!);
              },
            ),
          ],
        );
      },
    );
  }
}
