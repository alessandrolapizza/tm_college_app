import "package:flutter/material.dart";
import "package:settings_ui/settings_ui.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:tm_college_app/widgets/modular_settings_tile.dart';
import "../models/homework.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "../models/subject.dart";
import "./modular_alert_dialog.dart";

class StartNewSchoolYearSettingsBody extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  final MyDatabase database;

  final Notifications notifications;

  StartNewSchoolYearSettingsBody({
    @required this.sharedPreferences,
    @required this.database,
    @required this.notifications,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor),
      sections: [
        SettingsSection(
          title: Text("Commencer une nouvelle année scolaire"),
          tiles: [
            ModularSettingsTile(
              onPressedFunction: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return ModularAlertDialog(
                      themeColor: Theme.of(context).primaryColor,
                      title: Text("Commencer nouvelle année scolaire ?"),
                      content: Text(
                          "Es-tu sûr de vouloir commencer une nouvelle année scolaire ?"),
                      actionButtons: [
                        TextButton(
                          child: Text("Annuler"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          onPressed: () async {
                            List<Subject> subjects = await database.subjects();
                            subjects.forEach(
                              (subject) async {
                                await database.deleteSubject(
                                  subject: subject,
                                  notifications: notifications,
                                );
                              },
                            );
                            List<Homework> homeworks =
                                await database.homeworks();
                            homeworks.forEach(
                              (Homework homework) async {
                                await database.deleteHomework(
                                    homework: homework,
                                    notifications: notifications);
                              },
                            );
                            await sharedPreferences
                                .remove("firstTermBeginingDate");
                            await sharedPreferences
                                .remove("secondTermBeginingDate");
                            await sharedPreferences
                                .remove("secondTermEndingDate");
                            await sharedPreferences.remove("introductionSeen");
                            Navigator.popUntil(
                              context,
                              ModalRoute.withName("/"),
                            );
                            Navigator.pushReplacementNamed(context, "/");
                          },
                          child: Text(
                            "Oui, je suis sûr !",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
              hideArrow: true,
              title: "Confirmer",
              color: Colors.red,
            ),
          ],
        ),
        CustomSettingsSection(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Cette action remet à zéro toutes les données de l'application. C'est l'option parfaite si tu commences une nouvelles année scolaire !\n\nCe qui est supprimé :\n    - Les devoirs\n    - Les notes et moyennes\n    - Les matières\n    - Les dates de ton année scolaire\n\nCe qui est conservé :\n    - Les paramètres de notifications",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        )
      ],
    );
  }
}
