import "package:flutter_material_color_picker/flutter_material_color_picker.dart";
import "package:flutter/material.dart";
import "package:settings_ui/settings_ui.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/homework.dart";
import "../models/notifications.dart";
import "./advanced_notifications_day_number_picker.dart";
import "./fade_gradient.dart";
import "./modular_alert_dialog.dart";

class AdvancedNotificationsSettingsBody extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  AdvancedNotificationsSettingsBody({
    @required this.sharedPreferences,
    @required this.notifications,
  });

  @override
  _AdvancedNotificationsSettingsBodyState createState() =>
      _AdvancedNotificationsSettingsBodyState();
}

class _AdvancedNotificationsSettingsBodyState
    extends State<AdvancedNotificationsSettingsBody> {
  _changeNotificationsPriorityNumber(notificationsPriorityNumber) async {
    await showDialog(
      context: context,
      builder: (_) {
        return ModularAlertDialog(
          themeColor: Theme.of(context).primaryColor,
          title: Text("Sélectionner un nombre de jours"),
          content: FadeGradient(
            child: AdvancedNotificationsSettingsDayNumberPicker(
              sharedPreferences: widget.sharedPreferences,
              notificationsPriorityNumber: notificationsPriorityNumber,
            ),
          ),
        );
      },
    );
    await widget.notifications.rescheduleNotifications();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      lightTheme: SettingsThemeData(
          settingsListBackground: Theme.of(context).scaffoldBackgroundColor),
      sections: [
        SettingsSection(
          title: Text("Pastilles d'importances"),
          tiles: [
            SettingsTile(
              enabled: true,
              leading: CircleColor(
                color: Homework.priorityColorMap.values.toList()[0],
                circleSize: 20,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Homework.priorityColorMap.keys.toList()[0]),
                  Text(
                    (widget.sharedPreferences.getInt(
                                    "notificationsPriorityNumberWhite") ??
                                0) ==
                            0
                        ? "Aucune"
                        : widget.sharedPreferences.getInt(
                                    "notificationsPriorityNumberWhite") ==
                                1
                            ? "1 jour avant"
                            : "${widget.sharedPreferences.getInt("notificationsPriorityNumberWhite")} jours avant",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              onPressed: (_) async => _changeNotificationsPriorityNumber(0),
            ),
            SettingsTile(
              onPressed: (_) async => _changeNotificationsPriorityNumber(1),
              leading: CircleColor(
                color: Colors.green,
                circleSize: 20,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Normale"),
                  Text(
                      (widget.sharedPreferences.getInt(
                                      "notificationsPriorityNumberGreen") ??
                                  1) ==
                              0
                          ? "Aucune"
                          : (widget.sharedPreferences.getInt(
                                          "notificationsPriorityNumberGreen") ??
                                      1) ==
                                  1
                              ? "1 jour avant"
                              : "${widget.sharedPreferences.getInt("notificationsPriorityNumberGreen") ?? 1} jours avant",
                      style: TextStyle(
                        color: Colors.grey[600],
                      )),
                ],
              ),
            ),
            SettingsTile(
              onPressed: (_) async => _changeNotificationsPriorityNumber(2),
              leading: CircleColor(
                color: Colors.orange,
                circleSize: 20,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Moyenne"),
                  Text(
                    (widget.sharedPreferences.getInt(
                                    "notificationsPriorityNumberOrange") ??
                                3) ==
                            0
                        ? "Aucune"
                        : widget.sharedPreferences.getInt(
                                    "notificationsPriorityNumberOrange") ==
                                1
                            ? "1 jour avant"
                            : "${widget.sharedPreferences.getInt("notificationsPriorityNumberOrange") ?? 3} jours avant",
                    style: TextStyle(color: Colors.grey[600]),
                  )
                ],
              ),
            ),
            SettingsTile(
              onPressed: (_) async => _changeNotificationsPriorityNumber(3),
              leading: CircleColor(
                color: Colors.red,
                circleSize: 20,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Urgente"),
                  Text(
                    (widget.sharedPreferences
                                    .getInt("notificationsPriorityNumberRed") ??
                                5) ==
                            0
                        ? "Aucune"
                        : widget.sharedPreferences
                                    .getInt("notificationsPriorityNumberRed") ==
                                1
                            ? "1 jour avant"
                            : "${widget.sharedPreferences.getInt("notificationsPriorityNumberRed") ?? 5} jours avant",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        CustomSettingsSection(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Ces paramètres permettent de changer individuellement pour chaque pastille d'importance le nombre de notifications à envoyer. \n\nExemple : J'ai règlé ma pastille Moyenne sur 2 jours. Je l'applique sur un devoir pour le 10 janvier. Je recevrai alors une notification le 9 et le 8 janvier à l'heure de rappel réglée.",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        )
      ],
    );
  }
}
