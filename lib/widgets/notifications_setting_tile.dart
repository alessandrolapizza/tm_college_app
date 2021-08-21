import "package:flutter/material.dart";
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/notifications.dart';
import "package:notification_permissions/notification_permissions.dart";

class NotificationsSettingTile extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  NotificationsSettingTile({
    @required this.sharedPreferences,
    @required this.notifications,
  });

  @override
  _NotificationsSettingTileState createState() =>
      _NotificationsSettingTileState();
}

class _NotificationsSettingTileState extends State<NotificationsSettingTile>
    with WidgetsBindingObserver {
  Future<String> permissionStatusFuture;

  _toggleNotifications(toggleState) async {
    if (toggleState) {
      NotificationPermissions.requestNotificationPermissions(
        iosSettings: const NotificationSettingsIos(
          sound: true,
          badge: true,
          alert: true,
        ),
      );
      getCheckNotificationPermStatus();
      await widget.sharedPreferences.setBool("notificationsActivated", true);
    } else {
      await widget.sharedPreferences.setBool("notificationsActivated", false);

      //suppr toutes les notifs
    }
    setState(() {});
  }

  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";

  @override
  void initState() {
    super.initState();
    permissionStatusFuture = getCheckNotificationPermStatus();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        permissionStatusFuture = getCheckNotificationPermStatus();
      });
    }
  }

  Future<String> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus().then(
      (status) {
        switch (status) {
          case PermissionStatus.denied:
            return permDenied;
          case PermissionStatus.granted:
            return permGranted;
          case PermissionStatus.unknown:
            return permUnknown;
          case PermissionStatus.provisional:
            return permProvisional;
          default:
            return null;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.sharedPreferences.getBool("notificationsActivated"));
    return FutureBuilder(
      future: permissionStatusFuture,
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.waiting) {
          child = SettingsTile.switchTile(
            title: "Notifications",
            onToggle: (_) {},
            switchValue: false,
            leading: Icon(Icons.notifications),
            enabled: false,
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data == permGranted &&
              widget.sharedPreferences.getBool("notificationsActivated")) {
            child = SettingsTile.switchTile(
              title: "Notifications",
              onToggle: (toggleState) => _toggleNotifications(toggleState),
              switchValue: true,
              leading: Icon(Icons.notifications),
              enabled: true,
            );
          } else {

            child = SettingsTile.switchTile(
              title: "Notifications",
              onToggle: (toggleState) => _toggleNotifications(toggleState),
              switchValue: false,
              leading: Icon(Icons.notifications),
              enabled: true,
            );
          }
        }
        return child;
      },
    );
  }
}
