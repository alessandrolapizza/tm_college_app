import "package:flutter/material.dart";
import "../models/homework.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "./app.dart";
import "./modular_alert_dialog.dart";
import "./modular_app_bar.dart";
import "./modular_floating_action_button.dart";
import "./modular_icon_button.dart";
import "./theme_controller.dart";
import "./view_homework_body.dart";

class ViewHomeworkScreen extends StatefulWidget {
  final MyDatabase database;

  final Notifications notifications;

  ViewHomeworkScreen({
    @required this.database,
    @required this.notifications,
  });

  @override
  _RouteAwareViewHomeworkScreenState createState() =>
      _RouteAwareViewHomeworkScreenState();
}

class _RouteAwareViewHomeworkScreenState extends State<ViewHomeworkScreen>
    with RouteAware {
  List<Homework> _updatedHomework;

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

  @override
  void didPopNext() {
    if (ModalRoute.of(context).settings.arguments != null) {
      _useUpdatedHomework = false;
    } else {
      _useUpdatedHomework = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;
    final Homework homework = arguments[0];
    final bool homePage = arguments[1];
    _useUpdatedHomework = true && _updatedHomework == null
        ? _useUpdatedHomework = false
        : _useUpdatedHomework;

    return ThemeController(
      color: _useUpdatedHomework
          ? _updatedHomework[0].subject.color
          : homework.subject.color,
      child: Scaffold(
        floatingActionButton: !homePage
            ? ModularFloatingActionButton(
                onPressedFunction: () async {
                  await Homework.homeworkChecker(
                    homework: homework,
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
                  _updatedHomework = await Navigator.pushNamed(
                    context,
                    "/edit_homework_screen",
                    arguments: [
                      _useUpdatedHomework ? _updatedHomework[0] : homework,
                      false
                    ],
                  ) as List<Homework>;
                  setState(() => _updatedHomework);
                },
                icon: Icons.edit_rounded,
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
                            color: homework.subject.color,
                            child: ModularAlertDialog(
                              themeColor: homework.subject.color,
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
                                      homework: homework,
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
                        homework: homework,
                        database: widget.database,
                        notifications: widget.notifications,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Devoir marqué comme \"complété\"."),
                        ),
                      );
                    },
                    icon: Icons.check_rounded,
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
                            color: homework.subject.color,
                            child: ModularAlertDialog(
                              themeColor: homework.subject.color,
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
                                      homework: homework,
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
          homework: _useUpdatedHomework ? _updatedHomework[0] : homework,
          homePage: homePage,
        ),
      ),
    );
  }
}
