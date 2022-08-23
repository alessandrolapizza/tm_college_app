import "package:flutter/material.dart";
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/widgets/fade_gradient.dart';
import 'package:tm_college_app/widgets/modular_app_bar.dart';
import 'package:tm_college_app/widgets/version_changelog_bloc.dart';

class ChangelogScreen extends StatelessWidget {
  final PackageInfo packageInfo;

  final SharedPreferences sharedPreferences;

  final bool fromSettings;

  ChangelogScreen({
    @required this.packageInfo,
    @required this.sharedPreferences,
    this.fromSettings = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: fromSettings
          ? null
          : [
              ElevatedButton(
                child: Text("OK !"),
                onPressed: () async {
                  await sharedPreferences.setBool("changelogSeen", true);
                  Navigator.pushReplacementNamed(context, "/");
                },
              )
            ],
      appBar: ModularAppBar(
        hideSettingsButton: true,
        title: Text("Notes de mises à jour"),
        centerTitle: fromSettings ? true : false,
        backArrow: fromSettings ? true : false,
      ),
      body: SafeArea(
        child: FadeGradient(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VersionChangelogBloc(
                  changelogText: "TODO",
                  version: "2.0.0",
                  packageInfo: packageInfo,
                ),
                VersionChangelogBloc(
                  version: "1.0.11",
                  changelogText:
                      "- Modifié l'apparence de la barre de navigation et du bouton flottant.\n- Corrigé bug lié aux notifications.",
                  packageInfo: packageInfo,
                ),
                VersionChangelogBloc(
                  version: "1.0.10",
                  changelogText:
                      "- Modifié l'apparence de la barre de navigation.\n- Corrigé bug lié aux notifications.",
                  packageInfo: packageInfo,
                ),
                VersionChangelogBloc(
                  version: "1.0.9",
                  changelogText:
                      "- Ajouté la possibilité de naviguer entre les différentes pages en swipant.\n- Modifié l'affichage des dates pour pouvoir se repérer plus facilement.\n- Modifié l'affichage des devoirs faits.",
                  packageInfo: packageInfo,
                ),
                VersionChangelogBloc(
                  version: "1.0.8",
                  changelogText: "Modifié les explications.",
                  packageInfo: packageInfo,
                ),
                VersionChangelogBloc(
                  version: "1.0.7",
                  changelogText:
                      "Modifié les explications dans les paramètres ainsi que dans les écrans de l'introduction.",
                  packageInfo: packageInfo,
                ),
                VersionChangelogBloc(
                  version: "1.0.4",
                  changelogText: "Modifié l'ordre des captures d'écran.",
                  packageInfo: packageInfo,
                ),
                VersionChangelogBloc(
                  version: "1.0.3",
                  changelogText:
                      "La barre de navigation est désormais plus claire.",
                  packageInfo: packageInfo,
                ),
                VersionChangelogBloc(
                  version: "1.0.2",
                  changelogText: "Initial release on stores.",
                  packageInfo: packageInfo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
