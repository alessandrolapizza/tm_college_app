import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/my_database.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/modular_app_bar.dart';
import 'package:tm_college_app/widgets/start_new_school_year_settings_body.dart';

class StartNewSchoolYearSettingsScreen extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  final MyDatabase database;

  final Notifications notifications;

  StartNewSchoolYearSettingsScreen({
    @required this.sharedPreferences,
    @required this.database,
    @required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        title: Text("Nouvelle Année Scolaire"),
        hideSettingsButton: true,
        backArrow: true,
      ),
      body: StartNewSchoolYearSettingsBody(
        sharedPreferences: sharedPreferences,
        database: database,
        notifications: notifications,
      ),
    );
  }
}
