import "package:flutter/material.dart";
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/widgets/app.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';
import 'package:tm_college_app/widgets/modular_icon_button.dart';
import 'package:tm_college_app/widgets/theme_controller.dart';

import 'package:tm_college_app/widgets/view_homework_body.dart';

import "../models/devoir.dart";
import "./modular_floating_action_button.dart";

import "./modular_app_bar.dart";
import "./modular_icon_button.dart";

class ViewHomeworkPage extends StatefulWidget {
  final BaseDeDonnees db;

  ViewHomeworkPage({@required this.db});

  @override
  _RouteAwareViewHomeworkPageState createState() =>
      _RouteAwareViewHomeworkPageState();
}

class _RouteAwareViewHomeworkPageState extends State<ViewHomeworkPage>
    with RouteAware {
  List<Devoir> _updatedHomework;

  bool _useUpdatedHomework = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    App.routeObserver.subscribe(
      this,
      ModalRoute.of(context),
    );
  }

  @override
  void dispose() {
    App.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _useUpdatedHomework = false;
  }

  void didPopNext() async {
    _useUpdatedHomework = true;
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;
    final Devoir homework = arguments[0];
    final bool homePage = arguments[1];
    _useUpdatedHomework = true && _updatedHomework == null
        ? _useUpdatedHomework = false
        : _useUpdatedHomework;

    return ThemeController(
      color: _useUpdatedHomework
          ? _updatedHomework[0].subject.couleurMatiere
          : homework.subject.couleurMatiere,
      child: Scaffold(
        floatingActionButton: !homePage
            ? ModularFloatingActionButton(
                onPressedFunction: () async {
                  await Devoir.homeworkChecker(
                    homework: homework,
                    db: widget.db,
                  );
                  Navigator.pop(context);
                },
                icon: Icons.settings_backup_restore_outlined,
              )
            : ModularFloatingActionButton(
                onPressedFunction: () async {
                  _updatedHomework = await Navigator.pushNamed(
                    context,
                    "/edit_homework_page",
                    arguments: [
                      _useUpdatedHomework ? _updatedHomework[0] : homework,
                      false
                    ],
                  ) as List<Devoir>;
                  setState(() => _updatedHomework);
                },
                icon: Icons.edit,
              ),
        appBar: ModularAppBar(
          hideSettingsButton: true,
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
                                  await widget.db.deleteHomework(homework);
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
                        db: widget.db,
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
                                  await widget.db.deleteHomework(homework);
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
          homework: _useUpdatedHomework ? _updatedHomework[0] : homework,
          homePage: homePage,
        ),
      ),
    );
  }
}
