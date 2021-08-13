import "package:flutter/material.dart";
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';
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
    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;
    final Devoir homework = arguments[0];
    final bool homePage = arguments[1];
    return ThemeController(
      color: homework.subject.couleurMatiere,
      child: Scaffold(
        floatingActionButton: ModularFloatingActionButton(
          onPressedFunction: () async {
            await Devoir.homeworkChecker(
              homework: homework,
              db: db,
            );
            Navigator.pop(context);
          },
          icon: homePage ? Icons.edit : Icons.settings_backup_restore_outlined,
        ),
        appBar: ModularAppBar(
          backArrow: true,
          actions: homePage
              ? [
                  ModularIconButton(
                    onPressedFunction: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) {
                          return ThemeController(
                            color: homework.subject.couleurMatiere,
                            child: ModularAlertDialog(
                              themeColor: homework.subject.couleurMatiere,
                              title: Text("Supprimer devoir ?"),
                              content: Text(
                                  "Es-tu sûr de vouloir supprimer ce devoir ?"),
                              actionButton: TextButton(
                                child: Text(
                                  "Supprimer",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  await db.deleteHomework(homework);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icons.delete,
                  ),
                  ModularIconButton(
                    onPressedFunction: () async {
                      await Devoir.homeworkChecker(
                        homework: homework,
                        db: db,
                      );
                      Navigator.pop(context);
                    },
                    icon: Icons.check,
                  )
                ]
              : [
                  ModularIconButton(
                    onPressedFunction: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (_) {
                          return ThemeController(
                            color: homework.subject.couleurMatiere,
                            child: ModularAlertDialog(
                              themeColor: homework.subject.couleurMatiere,
                              title: Text("Supprimer devoir ?"),
                              content: Text(
                                  "Es-tu sûr de vouloir supprimer ce devoir ?"),
                              actionButton: TextButton(
                                child: Text(
                                  "Supprimer",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  await db.deleteHomework(homework);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: Icons.delete,
                  )
                ],
          title: "Détails du devoir",
          centerTitle: true,
        ),
        body: ViewHomeworkBody(
          homework: homework,
          homePage: homePage,
        ),
      ),
    );
  }
}
