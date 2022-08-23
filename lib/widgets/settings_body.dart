import 'package:confetti/confetti.dart';
import "package:flutter/material.dart";
import 'package:package_info_plus/package_info_plus.dart';
import "package:settings_ui/settings_ui.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:tm_college_app/widgets/changelog_screen.dart';
import 'package:tm_college_app/widgets/modular_settings_tile.dart';
import "../models/my_database.dart";
import "../models/notifications.dart";
import "./modular_alert_dialog.dart";

class SettingsBody extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  final MyDatabase database;

  final PackageInfo packageInfo;

  final ConfettiController confettiController;

  SettingsBody({
    @required this.database,
    @required this.notifications,
    @required this.sharedPreferences,
    @required this.packageInfo,
    @required this.confettiController,
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
          lightTheme: SettingsThemeData(
            settingsListBackground: Theme.of(context).scaffoldBackgroundColor,
          ),
          sections: [
            SettingsSection(
              title: Text("Notifications"),
              tiles: [
                SettingsTile.switchTile(
                  activeSwitchColor: Theme.of(context).primaryColor,
                  title: Text("Notifications"),
                  onToggle: (toggleState) async => await widget.notifications
                      .toggleNotifications(
                        toggleState: toggleState,
                        snapshotData: snapshot.data,
                      )
                      .then((_) => setState(() {})),
                  initialValue: snapshot.hasData &&
                          (widget.sharedPreferences
                                  .getBool("notificationsActivated") ??
                              false)
                      ? snapshot.data == Notifications.permGranted
                      : false,
                  leading: Icon(Icons.notifications_rounded),
                  enabled: snapshot.hasData,
                ),
                SettingsTile(
                  description: Text(
                    "L'heure de rappel correspond à l'heure à laquelle chaque jour les notifications seront distribuées, s'il y en a.",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  title: Row(
                    children: [
                      Text("Heure de rappel"),
                      Text(
                        widget.sharedPreferences
                                .getString("notificationsReminderHour") ??
                            "17:00",
                        style: TextStyle(color: Colors.grey[600]),
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                  leading: Icon(Icons.access_time_rounded),
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
                SettingsTile(
                  leading: Icon(Icons.edit_notifications_rounded),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Colors.grey,
                  ),
                  title: Text("Avancé"),
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
              title: Text("Dates"),
              tiles: [
                SettingsTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Colors.grey,
                  ),
                  leading: Icon(Icons.edit_calendar_rounded),
                  description: Text(
                    "Permet de changer les dates qui délimitent ton année scolaire.",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  title: Text(
                    "Changer les dates",
                  ),
                  onPressed: (_) {
                    Navigator.pushNamed(
                        context, "change_dates_settings_screen");
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text("Nouvelle Année Scolaire"),
              tiles: [
                SettingsTile(
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Colors.grey,
                  ),
                  leading: Icon(Icons.restart_alt_rounded),
                  description: Text(
                    "Permet de rénitialiser l'application pour une nouvelle année scolaire.",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  title: Text(
                    "Commencer une nouvelle Année Scolaire",
                  ),
                  onPressed: (_) {
                    Navigator.pushNamed(
                        context, "start_new_school_year_settings_screen");
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text("Notes de mises à jour"),
              tiles: [
                ModularSettingsTile(
                  description:
                      "Permet de voir les changements effectués au fil des mises à jour.",
                  icon: Icons.notes_rounded,
                  title: "Voir les notes de mises à jour",
                  onPressedFunction: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangelogScreen(
                        packageInfo: widget.packageInfo,
                        sharedPreferences: widget.sharedPreferences,
                        fromSettings: true,
                      ),
                    ),
                  ),
                )
              ],
            ),
            SettingsSection(
              tiles: [
                SettingsTile(
                  leading: Icon(Icons.contact_mail_rounded),
                  title: Text("Contact"),
                  description: Text("Une suggestion, un bug ou autre chose ? Fais-le savoir ! :)"),
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
                  leading: Icon(Icons.balance_rounded),
                  title: Text("Licences"),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: Colors.grey,
                  ),
                  onPressed: (_) => showLicensePage(
                    applicationVersion: "v.${widget.packageInfo.version}",
                    applicationLegalese: "alessandrolapizza",
                    context: context,
                    applicationIcon: Image.asset(
                      "assets/images/transparent_icon.png",
                      scale: 15,
                    ),
                  ),
                ),
                ModularSettingsTile(
                  icon: Icons.local_pizza_rounded,
                  value: "Made with <3",
                  title: "Version ${widget.packageInfo.version}",
                  onPressedFunction: () => widget.confettiController.play(),
                ),
              ],
              title: Text("À propos"),
            ),
          ],
        );
      },
    );
  }
}
