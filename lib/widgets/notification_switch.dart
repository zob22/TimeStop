import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timestop/widgets/utils/notification_status.dart';

class NotificationSwitch extends StatelessWidget {
  const NotificationSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationStatus>(
      builder: (context, notificationStatus, child) {
        return Row(children: [
          const Text('Enable Notification Widget:'),
          const Spacer(),
          Switch(
            value: notificationStatus.enableNotification,
            onChanged: (newValue) {
              notificationStatus.setNotificationStatus(newValue);
            },
          )
        ]);
      },
    );
  }
}