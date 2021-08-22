import "package:flutter/material.dart";
import 'package:settings_ui/settings_ui.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/notifications.dart';

class SettingsBody extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  SettingsBody({
    @required this.notifications,
    @required this.sharedPreferences,
  });

  @override
  _SettingsBodyState createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody>
    with WidgetsBindingObserver {
  Future<String> permissionStatusFuture;

  @override
  void initState() {
    super.initState();
    permissionStatusFuture =
        widget.notifications.getCheckNotificationPermStatus();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      setState(() {
        permissionStatusFuture =
            widget.notifications.getCheckNotificationPermStatus();
      });
    }
  }

  Future<bool> switchValue(String snapshotData) async {
    if ((widget.sharedPreferences.getString("notificationsActivated") ==
            "true") &&
        snapshotData == Notifications.permGranted) {
      return true;
    } else if (widget.sharedPreferences.getString("notificationsActivated") ==
        "true") {
      await widget.sharedPreferences
          .setString("notificationsActivated", "false");
      return false;
    } else {
      return false;
    }
  }

  Future<List> futureFunction() async {
    List test = [];
    test.add(await permissionStatusFuture);
    test.add(await switchValue(test[0]));
    return test;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.sharedPreferences.getBool("notifs"));
    return FutureBuilder(
      future: permissionStatusFuture,
      builder: (_, snapshot) {
        return SettingsList(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          sections: [
            SettingsSection(
              title: 'Notifications',
              tiles: [
                SettingsTile.switchTile(
                  title: "Notifications",
                  onToggle: (toggleState) async => await widget.notifications
                      .toggleNotifications(
                        toggleState: toggleState,
                        snapshotData: snapshot.data,
                      )
                      .then((_) => setState(() {})),
                  switchValue: snapshot.hasData &&
                          (widget.sharedPreferences.getBool("notifs") ?? false)
                      ? snapshot.data == Notifications.permGranted
                      : false,
                  leading: Icon(Icons.notifications),
                  enabled: snapshot.hasData,
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
                  },
                )
              ],
            ),
          ],
        );
      },
    );
  }
}