import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/notifications.dart";
import "./advanced_notifications_settings_body.dart";
import "./modular_app_bar.dart";

class AdvancedNotificationsSettingsScreen extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  AdvancedNotificationsSettingsScreen({
    @required this.sharedPreferences,
    @required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        backArrow: true,
        centerTitle: true,
        hideSettingsButton: true,
        title: Text("Notifications avancées"),
      ),
      body: AdvancedNotificationsSettingsBody(
        notifications: notifications,
        sharedPreferences: sharedPreferences,
      ),
    );
  }
}
