import "package:flutter/material.dart";
import 'package:settings_ui/settings_ui.dart';
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
              switchValue: true,
              onToggle: (bool value) {
                setState(() => test = value);
              },
            ),
            SettingsTile(
              title: "pending notifications",
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
            ),
            SettingsTile(
                title: "suppr notifs",
                onPressed: (_) async {
                  await FlutterLocalNotificationsPlugin().cancelAll();
                })
          ],
        ),
      ],
    );
  }
}
