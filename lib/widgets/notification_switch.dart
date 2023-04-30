import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timestop/widgets/utils/enable_notifications.dart';

class NotificationSwitch extends StatelessWidget {
  const NotificationSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EnableNotifications>(
      builder: (context, notificationStatus, child) {
        return Row(children: [
          const Text('Enable Notifications:'),
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