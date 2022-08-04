import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/my_database.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/change_dates_settings.dart';
import 'package:tm_college_app/widgets/modular_app_bar.dart';

class ChangeDatesSettingsScreen extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  final MyDatabase database;

  final Notifications notifications;


  ChangeDatesSettingsScreen({
    @required this.database,
    @required this.sharedPreferences,
    @required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        title: Text("Changer dates"),
        hideSettingsButton: true,
        backArrow: true,
        centerTitle: true,
      ),
      body: ChangeDatesSettings(
        notifications: notifications,
        database: database,
        sharedPreferences: sharedPreferences,
      ),
    );
  }
}
