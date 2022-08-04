import "package:flutter/material.dart";
import 'package:package_info_plus/package_info_plus.dart';
import "package:shared_preferences/shared_preferences.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "./modular_app_bar.dart";
import "./settings_body.dart";

class SettingsScreen extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  final MyDatabase database;

  final PackageInfo packageInfo;

  SettingsScreen({
    @required this.database,
    @required this.notifications,
    @required this.sharedPreferences,
    @required this.packageInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsBody(
        packageInfo: packageInfo,
        database: database,
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
