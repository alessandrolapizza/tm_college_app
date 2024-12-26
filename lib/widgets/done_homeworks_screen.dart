import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "../models/my_database.dart";
import "../models/notifications.dart";
import "../widgets/homeworks_list.dart";
import "../widgets/modular_app_bar.dart";

class DoneHomeworksScreen extends StatelessWidget {
  final MyDatabase database;

  final Notifications notifications;

  final SharedPreferences sharedPreferences;

  DoneHomeworksScreen({
    required this.database,
    required this.notifications,
    required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        hideSettingsButton: true,
        backArrow: true,
        centerTitle: true,
        title: Text("Devoirs complétés"),
      ),
      body: HomeworksList(
        scrollControllerHomeworks: ScrollController(),
        sharedPreferences: sharedPreferences,
        database: database,
        homePage: false,
        notifications: notifications,
      ),
    );
  }
}
