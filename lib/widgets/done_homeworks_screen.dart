import "package:flutter/material.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "../widgets/homeworks_list.dart";
import "../widgets/modular_app_bar.dart";

class DoneHomeworksScreen extends StatelessWidget {
  final MyDatabase database;

  final Notifications notifications;

  DoneHomeworksScreen({
    @required this.database,
    @required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        hideSettingsButton: true,
        backArrow: true,
        title: Text("Devoirs complétés"),
      ),
      body: HomeworksList(
        database: database,
        homePage: false,
        notifications: notifications,
      ),
    );
  }
}
