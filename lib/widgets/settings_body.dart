import "package:flutter/material.dart";
import 'package:settings_ui/settings_ui.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/models/devoir.dart';
import 'package:tm_college_app/models/notifications.dart';

class SettingsBody extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  final BaseDeDonnees database;

  SettingsBody({
    @required this.database,
    @required this.notifications,
    @required this.sharedPreferences,
  });

  @override
  _SettingsBodyState createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody>
    with WidgetsBindingObserver {
  Future<String> permissionStatusFuture;

  @override
  void initState() {
    super.initState();
    permissionStatusFuture =
        widget.notifications.getCheckNotificationPermStatus();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      setState(
        () {
          permissionStatusFuture =
              widget.notifications.getCheckNotificationPermStatus();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.sharedPreferences.getBool("notifs"));
    return FutureBuilder(
      future: permissionStatusFuture,
      builder: (_, snapshot) {
        return SettingsList(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          sections: [
            SettingsSection(
              title: 'Notifications',
              tiles: [
                SettingsTile.switchTile(
                  title: "Notifications",
                  onToggle: (toggleState) async => await widget.notifications
                      .toggleNotifications(
                        toggleState: toggleState,
                        snapshotData: snapshot.data,
                      )
                      .then((_) => setState(() {})),
                  switchValue: snapshot.hasData &&
                          (widget.sharedPreferences.getBool("notifs") ?? false)
                      ? snapshot.data == Notifications.permGranted
                      : false,
                  leading: Icon(Icons.notifications),
                  enabled: snapshot.hasData,
                ),
                SettingsTile(
                  title: "Heure de rappel",
                  leading: Icon(Icons.access_time),
                  iosChevron: null,
                  subtitle: widget.sharedPreferences
                          .getString("notificationsReminderHour") ??
                      "17:00", // à changer
                  enabled: snapshot.hasData &&
                          (widget.sharedPreferences.getBool("notifs") ?? false)
                      ? snapshot.data == Notifications.permGranted
                      : false,
                  onPressed: (_) async {
                    TimeOfDay selectedTime;
                    List<Devoir> homeworks;
                    selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (selectedTime != null) {
                      await widget.sharedPreferences.setString(
                        "notificationsReminderHour",
                        selectedTime.format(context),
                      );

                      homeworks = await widget.database.homeworks();

                      homeworks.forEach(
                        (homework) async {
                          if (!homework.done) {
                            await widget.database.updateHomework(
                              Devoir(
                                content: homework.content,
                                done: homework.done,
                                id: homework.id,
                                subject: homework.subject,
                                dueDate: homework.dueDate,
                                priority: homework.priority,
                                subjectId: homework.subjectId,
                                notificationsIds: await widget.notifications
                                    .scheduleNotifications(
                                  homeworkDueDate: homework.dueDate,
                                  homeworkPriority: homework.priority,
                                  homeworkSubjectName: homework.subject.nom,
                                  oldNotifications: homework.notificationsIds,
                                ),
                              ),
                            );
                          }
                        },
                      );
                      setState(() {});
                    }
                  },
                ),
                SettingsTile(
                  title: "Avancé",
                  enabled: snapshot.hasData &&
                          (widget.sharedPreferences.getBool("notifs") ?? false)
                      ? snapshot.data == Notifications.permGranted
                      : false,
                  onPressed: (_) {
                    Navigator.pushNamed(
                        context, "/advanced_notifications_settings_screen");
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [],
              maxLines: 10,
              title:
                  "L'heure de rappel correspond à l'heure à laquelle chaque jours les notifications seront distribuées, s'il y en a.",
            ),
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: "pending notifications",
                  onPressed: (_) async {
                    final List<PendingNotificationRequest>
                        pendingNotificationRequests =
                        await FlutterLocalNotificationsPlugin()
                            .pendingNotificationRequests();
                    return showDialog<void>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: Text(
                            '${pendingNotificationRequests.length} pending notification '
                            'requests'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SettingsTile(
                  title: "suppr notifs",
                  onPressed: (_) async {
                    await FlutterLocalNotificationsPlugin().cancelAll();
                  },
                )
              ],
              title: "Super Secret Menu",
            ),
          ],
        );
      },
    );
  }
}
