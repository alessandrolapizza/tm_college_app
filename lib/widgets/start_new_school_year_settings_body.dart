import "package:flutter/material.dart";
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/my_database.dart';
import 'package:tm_college_app/models/homework.dart';
import 'package:tm_college_app/models/subject.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';

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
      sections: [
        SettingsSection(
          titleTextStyle: TextStyle(),
          title:
              "Qu'est-ce que l'action \"Commencer une nouvelle Année Scolaire\" fait-elle ?\n\nCette action remet à zéro toutes les données de l'application. Ainsi, tu pourras rentrer les nouvelles dates de ton année scolaire.\n\nCe qui est supprimé :\n    - Les devoirs\n    - Les notes et moyennes\n    - Les matières\n    - Les dates délimitants ton année scolaire\n\nCe qui est conservé :\n    - Les paramètres de notifications",
          maxLines: 100,
          tiles: [
            SettingsTile(
              onPressed: (_) {
                showDialog(
                  context: context,
                  builder: (_) {
                    return ModularAlertDialog(
                      themeColor: Theme.of(context).primaryColor,
                      title: Text("Commencer nouvelle Année Scolaire ?"),
                      content: Text(
                          "Es-tu sûr de vouloir commencer une nouvelle Année Scolaire ?"),
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
              iosChevron: null,
              title: "Confirmer",
              titleTextStyle: TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
            )
          ],
        )
      ],
    );
  }
}
