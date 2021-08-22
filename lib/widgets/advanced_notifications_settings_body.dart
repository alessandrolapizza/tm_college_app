import "package:flutter/material.dart";
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:settings_ui/settings_ui.dart';

class AdvancedNotificationsSettingsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      sections: [
        SettingsSection(
          title: "Pastilles d'importances",
          tiles: [
            SettingsTile(
              leading: CircleColor(
                color: Colors.white,
                circleSize: 20,
              ),
              title: "Indifférente",
              iosChevron: null,
              subtitle: "",
            ),
            SettingsTile(
              leading: CircleColor(
                color: Colors.green,
                circleSize: 20,
              ),
              title: "Normale",
              iosChevron: null,
              subtitle: "1 jour avant",
            ),
            SettingsTile(
              leading: CircleColor(
                color: Colors.orange,
                circleSize: 20,
              ),
              title: "Moyenne",
              iosChevron: null,
              subtitle: "3 jours avant",
            ),
            SettingsTile(
              leading: CircleColor(
                color: Colors.red,
                circleSize: 20,
              ),
              title: "Urgente",
              iosChevron: null,
              subtitle: "5 jours avant",
            ),
          ],
        ),
        SettingsSection(
          title:
              "Ces paramètres permettent de changer individuellement pour chaque pastille d'importance le nombre de notifications à envoyer. \n\nExemple : J'ai règlé ma pastille Moyenne sur 2 jours. Je l'applique sur un devoir pour le 10 janvier. Je recevrai alors une notification le 9 et le 8 janvier à l'heure de distribution réglée.",
          tiles: [],
          maxLines: 20,
        )
      ],
    );
  }
}
