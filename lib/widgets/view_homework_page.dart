import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/theme_controller.dart';

import 'package:tm_college_app/widgets/view_homework_body.dart';

import "../models/devoir.dart";
import "./modular_floating_action_button.dart";

import "./modular_app_bar.dart";

class ViewHomeworkPage extends StatelessWidget {
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.delete),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.check),
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
