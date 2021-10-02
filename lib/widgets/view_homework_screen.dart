import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "../models/homework.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "./modular_alert_dialog.dart";
import "./modular_app_bar.dart";
import "./modular_floating_action_button.dart";
import "./modular_icon_button.dart";
import "./theme_controller.dart";
import "./view_homework_body.dart";

class ViewHomeworkScreen extends StatefulWidget {
  final MyDatabase database;

  final Notifications notifications;

  final SharedPreferences sharedPreferences;

  ViewHomeworkScreen({
    @required this.database,
    @required this.notifications,
    @required this.sharedPreferences,
  });

  @override
  State<ViewHomeworkScreen> createState() => _ViewHomeworkScreenState();
}

class _ViewHomeworkScreenState extends State<ViewHomeworkScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.database.homeworks(),
      builder: (_, snapshot) {
        Widget child;
        Homework homeworkToUse;
        if (snapshot.hasData) {
          snapshot.data.forEach(
            (homework) {
              if (homework.id ==
                  widget.sharedPreferences.getString("homeworkId")) {
                homeworkToUse = homework;
              }
            },
          );
          child = ThemeController(
            color: homeworkToUse.subject.color,
            child: Scaffold(
              floatingActionButton: homeworkToUse.done
                  ? ModularFloatingActionButton(
                      onPressedFunction: () async {
                        await Homework.homeworkChecker(
                          homework: homeworkToUse,
                          database: widget.database,
                          notifications: widget.notifications,
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Devoir marqué comme \"non fait\"."),
                          ),
                        );
                      },
                      icon: Icons.settings_backup_restore_rounded,
                    )
                  : ModularFloatingActionButton(
                      onPressedFunction: () async {
                        Navigator.pushNamed(
                          context,
                          "/edit_homework_screen",
                          arguments: [
                            homeworkToUse,
                            false,
                          ],
                        ).then((_) => setState(() {}));
                      },
                      icon: Icons.edit_rounded,
                    ),
              appBar: ModularAppBar(
                hideSettingsButton: true,
                backArrow: true,
                actions: !homeworkToUse.done
                    ? [
                        ModularIconButton(
                          onPressedFunction: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) {
                                return ThemeController(
                                  color: homeworkToUse.subject.color,
                                  child: ModularAlertDialog(
                                    themeColor: homeworkToUse.subject.color,
                                    title: Text("Supprimer devoir ?"),
                                    content: Text(
                                        "Es-tu sûr de vouloir supprimer ce devoir ?"),
                                    actionButtons: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Annuler"),
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Supprimer",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          await widget.database.deleteHomework(
                                            homework: homeworkToUse,
                                            notifications: widget.notifications,
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icons.delete_rounded,
                        ),
                        ModularIconButton(
                          onPressedFunction: () async {
                            await Homework.homeworkChecker(
                              homework: homeworkToUse,
                              database: widget.database,
                              notifications: widget.notifications,
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Devoir marqué comme \"complété\"."),
                              ),
                            );
                          },
                          icon: Icons.check_rounded,
                        )
                      ]
                    : [
                        ModularIconButton(
                          onPressedFunction: () async {
                            await widget.sharedPreferences
                                .setBool("unwantedRoute", true);
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) {
                                return ThemeController(
                                  color: homeworkToUse.subject.color,
                                  child: ModularAlertDialog(
                                    themeColor: homeworkToUse.subject.color,
                                    title: Text("Supprimer devoir ?"),
                                    content: Text(
                                        "Es-tu sûr de vouloir supprimer ce devoir ?"),
                                    actionButtons: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Annuler"),
                                      ),
                                      TextButton(
                                        child: Text(
                                          "Supprimer",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          await widget.database.deleteHomework(
                                            homework: homeworkToUse,
                                            notifications: widget.notifications,
                                          );
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: Icons.delete_rounded,
                        )
                      ],
                title: Text("Détails du devoir"),
                centerTitle: true,
              ),
              body: ViewHomeworkBody(
                homePage: !homeworkToUse.done,
                homework: homeworkToUse,
              ),
            ),
          );
        } else {
          child = Scaffold(
            appBar: ModularAppBar(
              backArrow: true,
              hideSettingsButton: true,
              centerTitle: true,
              title: Text("Chargement..."),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return child;
      },
    );
  }
}
