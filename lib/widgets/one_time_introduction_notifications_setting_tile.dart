import "package:flutter/material.dart";
import "package:settings_ui/settings_ui.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/notifications.dart";

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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
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
        return Container(
          width: 1000,
          height: 100,
          child: SettingsList(
              physics: NeverScrollableScrollPhysics(),
              lightTheme: SettingsThemeData(
                  settingsListBackground:
                      Theme.of(context).scaffoldBackgroundColor),
              sections: [
                SettingsSection(tiles: [
                  SettingsTile.switchTile(
                    activeSwitchColor: Theme.of(context).primaryColor,
                    title: Text("Notifications"),
                    onToggle: (toggleState) async => await widget.notifications
                        .toggleNotifications(
                          toggleState: toggleState,
                          snapshotData: snapshot.data,
                        )
                        .then((_) => setState(() {})),
                    initialValue: snapshot.hasData &&
                            (widget.sharedPreferences
                                    .getBool("notificationsActivated") ??
                                false)
                        ? snapshot.data == Notifications.permGranted
                        : false,
                    leading: Icon(Icons.notifications_rounded),
                    enabled: snapshot.hasData,
                  )
                ])
              ]),
        );
      },
    );
  }
}
