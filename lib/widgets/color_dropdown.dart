import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timestop/widgets/background.dart';

class ColorDropdown extends StatelessWidget {
  const ColorDropdown({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<Background>(builder: (context, background, child) {
      return Row(
        children: [
          const Text('Color scheme'),
          const Spacer(),
          DropdownButton(
            dropdownColor: background.selectedColor.withOpacity(0.8),
            value: background.selectedColor,
            items: background.colors.map((colorPreview) {
              return DropdownMenuItem(
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
              );
            }).toList(),
            onChanged: (value) {
              background.setColor(value!);
            },
          ),
        ],
      );
    });
  }
}
