import "package:flutter/material.dart";
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/widgets/homeworks_list.dart';
import 'package:tm_college_app/widgets/modular_app_bar.dart';

class DoneHomeworksPage extends StatelessWidget {
  final BaseDeDonnees db;

  DoneHomeworksPage({@required this.db});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        hideSettingsButton: true,
        backArrow: true,
        title: "Devoirs complétés",
      ),
      body: HomeworksList(
        db: db,
        homePage: false,
      ),
    );
  }
}
