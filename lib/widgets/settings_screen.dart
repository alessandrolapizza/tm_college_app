import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/modular_app_bar.dart';
import 'package:tm_college_app/widgets/settings_body.dart';

class SettingsScreen extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  SettingsScreen({
    @required this.notifications,
    @required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsBody(
        sharedPreferences: sharedPreferences,
        notifications: notifications,
      ),
      appBar: ModularAppBar(
        hideSettingsButton: true,
        backArrow: true,
        centerTitle: true,
        title: Text("Paramètres"),
      ),
    );
  }
}
