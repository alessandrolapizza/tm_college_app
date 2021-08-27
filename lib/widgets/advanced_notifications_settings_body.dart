import "package:flutter/material.dart";
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/devoir.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/advanced_notifications_day_number_picker.dart';
import 'package:tm_college_app/widgets/fade_gradient.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      sections: [
        SettingsSection(
          title: "Pastilles d'importances",
          tiles: [
            SettingsTile(
              enabled: true,
              leading: CircleColor(
                color: Devoir.priorityColorMap.values.toList()[0],
                circleSize: 20,
              ),
              title: Devoir.priorityColorMap.keys.toList()[0],
              iosChevron: null,
              subtitle: (widget.sharedPreferences
                              .getInt("notificationsPriorityNumberWhite") ??
                          0) ==
                      0
                  ? "Aucune"
                  : widget.sharedPreferences
                              .getInt("notificationsPriorityNumberWhite") ==
                          1
                      ? "1 jour avant"
                      : "${widget.sharedPreferences.getInt("notificationsPriorityNumberWhite")} jours avant",
              onPressed: (_) async => _changeNotificationsPriorityNumber(0),
            ),
            SettingsTile(
              onPressed: (_) async => _changeNotificationsPriorityNumber(1),
              leading: CircleColor(
                color: Colors.green,
                circleSize: 20,
              ),
              title: "Normale",
              iosChevron: null,
              subtitle: (widget.sharedPreferences
                              .getInt("notificationsPriorityNumberGreen") ??
                          1) ==
                      0
                  ? "Aucune"
                  : widget.sharedPreferences
                              .getInt("notificationsPriorityNumberGreen") ==
                          1
                      ? "1 jour avant"
                      : "${widget.sharedPreferences.getInt("notificationsPriorityNumberGreen") ?? 1} jours avant",
            ),
            SettingsTile(
              onPressed: (_) async => _changeNotificationsPriorityNumber(2),
              leading: CircleColor(
                color: Colors.orange,
                circleSize: 20,
              ),
              title: "Moyenne",
              iosChevron: null,
              subtitle: (widget.sharedPreferences
                              .getInt("notificationsPriorityNumberOrange") ??
                          3) ==
                      0
                  ? "Aucune"
                  : widget.sharedPreferences
                              .getInt("notificationsPriorityNumberOrange") ==
                          1
                      ? "1 jour avant"
                      : "${widget.sharedPreferences.getInt("notificationsPriorityNumberOrange") ?? 3} jours avant",
            ),
            SettingsTile(
              onPressed: (_) async => _changeNotificationsPriorityNumber(3),
              leading: CircleColor(
                color: Colors.red,
                circleSize: 20,
              ),
              title: "Urgente",
              iosChevron: null,
              subtitle: (widget.sharedPreferences
                              .getInt("notificationsPriorityNumberRed") ??
                          5) ==
                      0
                  ? "Aucune"
                  : widget.sharedPreferences
                              .getInt("notificationsPriorityNumberRed") ==
                          1
                      ? "1 jour avant"
                      : "${widget.sharedPreferences.getInt("notificationsPriorityNumberRed") ?? 5} jours avant",
            ),
          ],
        ),
        SettingsSection(
          titleTextStyle: TextStyle(),
          title:
              "Ces paramètres permettent de changer individuellement pour chaque pastille d'importance le nombre de notifications à envoyer. \n\nExemple : J'ai règlé ma pastille Moyenne sur 2 jours. Je l'applique sur un devoir pour le 10 janvier. Je recevrai alors une notification le 9 et le 8 janvier à l'heure de distribution réglée.",
          tiles: [],
          maxLines: 20,
        )
      ],
    );
  }
}
