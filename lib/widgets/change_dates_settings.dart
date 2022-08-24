import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/grade.dart';
import 'package:tm_college_app/models/homework.dart';
import 'package:tm_college_app/models/my_database.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';
import 'package:tm_college_app/widgets/modular_settings_tile.dart';

class ChangeDatesSettings extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final MyDatabase database;

  final Notifications notifications;

  final Function showDoneButtonFunction;

  ChangeDatesSettings({
    @required this.sharedPreferences,
    this.database,
    this.notifications,
    this.showDoneButtonFunction,
  });

  @override
  State<ChangeDatesSettings> createState() => _ChangeDatesSettingsState();
}

class _ChangeDatesSettingsState extends State<ChangeDatesSettings> {
  DateTime getDateTime({@required String date}) {
    return widget.sharedPreferences.getString(date) == null
        ? null
        : DateTime.parse(
            widget.sharedPreferences.getString(date),
          );
  }

  void selectFirstTermBeginingDate() async {
    DateTime date = await showDatePicker(
      confirmText: "OK",
      cancelText: "Annuler",
      context: context,
      initialDate: getDateTime(date: "firstTermBeginingDate") == null
          ? DateTime.now()
          : getDateTime(date: "firstTermBeginingDate"),
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: getDateTime(date: "secondTermBeginingDate") != null
          ? getDateTime(date: "secondTermBeginingDate").subtract(
              Duration(days: 1),
            )
          : DateTime(DateTime.now().year + 1, 12, 29),
    );
    if (date != null) {
      if (widget.database != null) {
        List<Homework> outHomeworks = await Homework.outHomeworks(
          database: widget.database,
          sharedPreferences: widget.sharedPreferences,
          firstTermBeginingDate: date,
        );
        List<Grade> outGrades = await Grade.outGrades(
          database: widget.database,
          sharedPreferences: widget.sharedPreferences,
          firstTermBeginingDate: date,
        );
        if (outHomeworks.isNotEmpty || outGrades.isNotEmpty) {
          showDialog(
            context: context,
            builder: (_) {
              return ModularAlertDialog(
                themeColor: Theme.of(context).primaryColor,
                title: Text("Changer date de début du premier semestre ?"),
                content: Text(
                    "Tu as des${outHomeworks.isNotEmpty ? " devoirs" : ""}${outGrades.isNotEmpty ? " et notes" : ""} en dehors de la période que tu viens de régler. En continuant, ${outGrades.isNotEmpty && outHomeworks.isNotEmpty ? "ils" : outGrades.isNotEmpty ? "elles" : "ils"} seront supprimé${outGrades.isNotEmpty && outHomeworks.isNotEmpty ? "" : outGrades.isNotEmpty ? "e" : ""}s."),
                actionButtons: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Annuler"),
                  ),
                  TextButton(
                    child: Text(
                      "Continuer !",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      outHomeworks.forEach(
                        (homework) async {
                          await widget.database.deleteHomework(
                            homework: homework,
                            notifications: widget.notifications,
                          );
                        },
                      );
                      outGrades.forEach(
                        (grade) async {
                          await widget.database.deleteGrade(
                            grade.id,
                          );
                        },
                      );
                      await widget.sharedPreferences
                          .setString("firstTermBeginingDate", date.toString());
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        } else {
          await widget.sharedPreferences
              .setString("firstTermBeginingDate", date.toString());
          setState(() {});
        }
      } else {
        await widget.sharedPreferences
            .setString("firstTermBeginingDate", date.toString());
        setState(() {});
      }
    }
  }

  void selectSecondTermBeginingDate() async {
    DateTime date = await showDatePicker(
      confirmText: "OK",
      cancelText: "Annuler",
      context: context,
      initialDate: getDateTime(date: "secondTermBeginingDate") == null
          ? DateTime.parse(
              widget.sharedPreferences.getString("firstTermBeginingDate"),
            ).add(
              Duration(days: 1),
            )
          : getDateTime(date: "secondTermBeginingDate"),
      firstDate: DateTime.parse(
        widget.sharedPreferences.getString("firstTermBeginingDate"),
      ).add(
        Duration(days: 1),
      ),
      lastDate: getDateTime(date: "secondTermEndingDate") != null
          ? getDateTime(date: "secondTermEndingDate").subtract(
              Duration(days: 1),
            )
          : DateTime(DateTime.now().year + 1, 12, 30),
    );
    if (date != null) {
      await widget.sharedPreferences
          .setString("secondTermBeginingDate", date.toString());
      setState(() {});
    }
  }

  void selectSecondTermEndingDate() async {
    DateTime date = await showDatePicker(
      confirmText: "OK",
      cancelText: "Annuler",
      context: context,
      initialDate: getDateTime(date: "secondTermEndingDate") == null
          ? DateTime.parse(
              widget.sharedPreferences.getString("secondTermBeginingDate"),
            ).add(
              Duration(days: 1),
            )
          : getDateTime(date: "secondTermEndingDate"),
      firstDate: DateTime.parse(
        widget.sharedPreferences.getString("secondTermBeginingDate"),
      ).add(
        Duration(days: 1),
      ),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
    );
    if (date != null) {
      if (widget.database != null) {
        List<Homework> outHomeworks = await Homework.outHomeworks(
          database: widget.database,
          sharedPreferences: widget.sharedPreferences,
          secondTermEndingDate: date,
        );
        List<Grade> outGrades = await Grade.outGrades(
          database: widget.database,
          sharedPreferences: widget.sharedPreferences,
          secondTermEndingDate: date,
        );
        if (outHomeworks.isNotEmpty) {
          showDialog(
            context: context,
            builder: (_) {
              return ModularAlertDialog(
                themeColor: Theme.of(context).primaryColor,
                title: Text("Changer date de fin du deuxième semestre ?"),
                content: Text(
                    "Tu as des${outHomeworks.isNotEmpty ? " devoirs" : ""}${outGrades.isNotEmpty ? " et notes" : ""} en dehors de la période que tu viens de régler. En continuant, ${outGrades.isNotEmpty && outHomeworks.isNotEmpty ? "ils" : outGrades.isNotEmpty ? "elles" : "ils"} seront supprimé${outGrades.isNotEmpty && outHomeworks.isNotEmpty ? "" : outGrades.isNotEmpty ? "e" : ""}s."),
                actionButtons: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Annuler"),
                  ),
                  TextButton(
                    child: Text(
                      "Continuer !",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () async {
                      outHomeworks.forEach(
                        (homework) async {
                          await widget.database.deleteHomework(
                            homework: homework,
                            notifications: widget.notifications,
                          );
                        },
                      );
                      outGrades.forEach(
                        (grade) async {
                          await widget.database.deleteGrade(
                            grade.id,
                          );
                        },
                      );
                      await widget.sharedPreferences
                          .setString("secondTermEndingDate", date.toString());
                      setState(() {});
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        } else {
          await widget.sharedPreferences
              .setString("secondTermEndingDate", date.toString());
          setState(() {});
        }
      } else {
        await widget.sharedPreferences
            .setString("secondTermEndingDate", date.toString());
        setState(() {});
        widget.showDoneButtonFunction(show: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      physics: widget.database == null ? NeverScrollableScrollPhysics() : null,
      shrinkWrap: widget.database == null ? true : false,
      lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor),
      sections: [
        SettingsSection(
          title: widget.database == null ? null : Text("Dates des semestres"),
          tiles: [
            ModularSettingsTile(
              hideArrow: true,
              onPressedFunction: selectFirstTermBeginingDate,
              title: "Début du premier semestre",
              value:
                  widget.sharedPreferences.getString("firstTermBeginingDate") ==
                          null
                      ? null
                      : DateFormat("dd.MM.y").format(
                          DateTime.parse(
                            widget.sharedPreferences
                                .getString("firstTermBeginingDate"),
                          ),
                        ),
              leading: Icon(Icons.edit_calendar_rounded),
            ),
            ModularSettingsTile(
              hideArrow: true,
              enabled:
                  widget.sharedPreferences.getString("firstTermBeginingDate") !=
                      null,
              onPressedFunction: selectSecondTermBeginingDate,
              title: "Début du deuxième semestre",
              leading: Icon(Icons.edit_calendar_rounded),
              value: widget.sharedPreferences
                          .getString("secondTermBeginingDate") ==
                      null
                  ? null
                  : DateFormat("dd.MM.y").format(
                      DateTime.parse(
                        widget.sharedPreferences
                            .getString("secondTermBeginingDate"),
                      ),
                    ),
            ),
            ModularSettingsTile(
              hideArrow: true,
              enabled: widget.sharedPreferences
                      .getString("secondTermBeginingDate") !=
                  null,
              onPressedFunction: selectSecondTermEndingDate,
              title: "Fin du deuxième semestre",
              leading: Icon(Icons.edit_calendar_rounded),
              value:
                  widget.sharedPreferences.getString("secondTermEndingDate") ==
                          null
                      ? null
                      : DateFormat("dd.MM.y").format(
                          DateTime.parse(
                            widget.sharedPreferences
                                .getString("secondTermEndingDate"),
                          ),
                        ),
            ),
          ],
        ),
        widget.database == null
            ? null
            : CustomSettingsSection(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(children: [
                    Text(
                      "Les dates de début et de fin de semestres servent à calculer tes moyennes correctement ainsi qu'à déterminer la période valide où tu peux entrer de nouveaux devoirs.\n\nSi tu commences une nouvelle année scolaire, ce n'est peut-être pas l'option que tu cherches. Voir : ",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Center(
                      child: TextButton(
                        child: Text("Commencer une nouvelle année scolaire"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                              context, "start_new_school_year_settings_screen");
                        },
                      ),
                    ),
                    Text(
                      "\nPour rappel, le calcul de la moyenne se fait comme suit :\n\nMoyenne = (Moyenne du premier semestre arrondie au dixième + Moyenne du deuxième semestre arrondie au dixième) / 2\n\n",
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  ]),
                ),
              )
      ],
    );
  }
}
