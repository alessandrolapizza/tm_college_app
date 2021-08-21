import "package:flutter/material.dart";
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/notifications.dart';

class OneTimeIntroductionNotificationsSettingTile extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  OneTimeIntroductionNotificationsSettingTile({
    @required this.sharedPreferences,
    @required this.notifications,
  });

  @override
  _OneTimeIntroductionNotificationsSettingTileState createState() =>
      _OneTimeIntroductionNotificationsSettingTileState();
}

class _OneTimeIntroductionNotificationsSettingTileState
    extends State<OneTimeIntroductionNotificationsSettingTile>
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: permissionStatusFuture,
      builder: (_, snapshot) {
        return SettingsTile.switchTile(
          title: "Notifications",
          onToggle: (toggleState) async => await widget.notifications
              .toggleNotifications(toggleState)
              .then((_) => setState(() {})),
          switchValue: snapshot.data == Notifications.permGranted &&
              widget.sharedPreferences.getBool("notificationsActivated"),
          leading: Icon(Icons.notifications),
          enabled: snapshot.hasData,
        );
      },
    );
  }
}
