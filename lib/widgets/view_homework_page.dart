import "package:flutter/material.dart";
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/widgets/modular_icon_button.dart';
import 'package:tm_college_app/widgets/theme_controller.dart';

import 'package:tm_college_app/widgets/view_homework_body.dart';

import "../models/devoir.dart";
import "./modular_floating_action_button.dart";

import "./modular_app_bar.dart";
import "./modular_icon_button.dart";

class ViewHomeworkPage extends StatelessWidget {
  final BaseDeDonnees db;

  ViewHomeworkPage({@required this.db});

  @override
  Widget build(BuildContext context) {
    final Devoir homework = ModalRoute.of(context).settings.arguments;
    return ThemeController(
      color: homework.subject.couleurMatiere,
      child: Scaffold(
        floatingActionButton: ModularFloatingActionButton(
          onPressedFunction: null,
          icon: Icons.edit,
        ),
        appBar: ModularAppBar(
          backArrow: true,
          actions: [
            ModularIconButton(
              onPressedFunction: () {},
              icon: Icons.delete,
            ),
            ModularIconButton(
              onPressedFunction: () async {
                await Devoir.homeworkChecker(
                  homework: homework,
                  done: true,
                  db: db,
                );
                Navigator.pop(context);
              },
              icon: Icons.check,
            )
          ],
          title: "Détails du devoir",
          centerTitle: true,
        ),
        body: ViewHomeworkBody(homework: homework),
      ),
    );
  }
}
