import "package:flutter/material.dart";
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/my_database.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';

class SettingsBody extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  final MyDatabase database;

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
  Future<String> _permissionStatusFuture;

  @override
  void initState() {
    super.initState();
    _permissionStatusFuture =
        widget.notifications.getCheckNotificationPermStatus();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(
        () {
          _permissionStatusFuture =
              widget.notifications.getCheckNotificationPermStatus();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _permissionStatusFuture,
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
                          (widget.sharedPreferences
                                  .getBool("notificationsActivated") ??
                              false)
                      ? snapshot.data == Notifications.permGranted
                      : false,
                  leading: Icon(Icons.notifications_rounded),
                  enabled: snapshot.hasData,
                ),
                SettingsTile(
                  title: "Heure de rappel",
                  leading: Icon(Icons.access_time_rounded),
                  iosChevron: null,
                  subtitle: widget.sharedPreferences
                          .getString("notificationsReminderHour") ??
                      "17:00",
                  enabled: snapshot.hasData &&
                          (widget.sharedPreferences
                                  .getBool("notificationsActivated") ??
                              false)
                      ? snapshot.data == Notifications.permGranted
                      : false,
                  onPressed: (_) async {
                    await showTimePicker(
                      cancelText: "Annuler",
                      confirmText: "OK",
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                        DateTime(
                          0,
                          0,
                          0,
                          int.parse(
                            (widget.sharedPreferences.getString(
                                        "notificationsReminderHour") ??
                                    "17:00")
                                .substring(0, 2),
                          ),
                          int.parse(
                            (widget.sharedPreferences.getString(
                                        "notificationsReminderHour") ??
                                    "17:00")
                                .substring(3, 5),
                          ),
                        ),
                      ),
                    ).then(
                      (selectedTime) async {
                        if (selectedTime != null) {
                          widget.notifications.changeNotificationsTime(
                              selectedTime: selectedTime, context: context);
                          setState(() {});
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [],
              titleTextStyle: TextStyle(),
              maxLines: 10,
              //   titleTextStyle: TextStyle(),
              title:
                  "L'heure de rappel correspond à l'heure à laquelle chaque jours les notifications seront distribuées, s'il y en a.",
            ),
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: "Avancé",
                  enabled: snapshot.hasData &&
                          (widget.sharedPreferences
                                  .getBool("notificationsActivated") ??
                              false)
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
              title: "Nouvelle Année Scolaire",
              tiles: [
                SettingsTile(
                  title: "Commencer une nouvelle Année Scolaire",
                  onPressed: (_) {
                    Navigator.pushNamed(
                        context, "start_new_school_year_settings_screen");
                  },
                ),
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile(
                  title: "Contact",
                  onPressed: (_) {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return ModularAlertDialog(
                          themeColor: Theme.of(context).primaryColor,
                          title: Text("Contact"),
                          content: FittedBox(
                            child: Row(
                              children: [
                                Text("Email : "),
                                SelectableText(
                                  "monanneescolaire.app@gmail.com",
                                  selectionControls:
                                      MaterialTextSelectionControls(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SettingsTile(
                  title: "Licences",
                  onPressed: (_) => showLicensePage(
                    applicationVersion: "v.1.0.0",
                    applicationLegalese: "Made with <3 🍕",
                    context: context,
                    applicationIcon: Image.asset(
                      "assets/images/transparent_icon.png",
                      scale: 15,
                    ),
                  ),
                ),
              ],
              title: "À propos",
            ),
          ],
        );
      },
    );
  }
}
