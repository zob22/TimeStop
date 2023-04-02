import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timestop/widgets/utils/time_format.dart';

class TimeSwitch extends StatelessWidget {
  const TimeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeFormat>(
      builder: (context, timeFormat, child) {
        return Row(children: [
          const Text('Display Hours:'),
          const Spacer(),
          Switch(
            value: timeFormat.displayHours,
            onChanged: (newValue) {
              timeFormat.setTime(newValue);
            },
          )
        ]);
      },
    );
  }
}
