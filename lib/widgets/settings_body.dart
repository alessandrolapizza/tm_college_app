import "package:flutter/material.dart";
import 'package:settings_ui/settings_ui.dart';
import 'package:tm_college_app/models/notifications.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";

class SettingsBody extends StatefulWidget {
  @override
  _SettingsBodyState createState() => _SettingsBodyState();
}

var test = true;

class _SettingsBodyState extends State<SettingsBody> {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      sections: [
        SettingsSection(
          title: 'Notifications',
          tiles: [
            SettingsTile.switchTile(
              title: 'Utiliser les notifications',
              leading: Icon(Icons.notifications),
              switchValue: Notifications.notificationsPermissionGranted,
              onToggle: (bool value) {
                setState(() => test = value);
              },
            ),
            SettingsTile(
              title: "test",
              onPressed: (_) async {
                final List<PendingNotificationRequest>
                    pendingNotificationRequests =
                    await FlutterLocalNotificationsPlugin()
                        .pendingNotificationRequests();
                return showDialog<void>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    content: Text(
                        '${pendingNotificationRequests.length} pending notification '
                        'requests'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ],
    );
  }
}
