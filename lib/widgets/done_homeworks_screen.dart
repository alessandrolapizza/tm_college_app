import "package:flutter/material.dart";
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/homeworks_list.dart';
import 'package:tm_college_app/widgets/modular_app_bar.dart';

class DoneHomeworksScreen extends StatelessWidget {
  final BaseDeDonnees db;

  final Notifications notifications;

  DoneHomeworksScreen({
    @required this.db,
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
        db: db,
        homePage: false,
        notifications: notifications,
      ),
    );
  }
}