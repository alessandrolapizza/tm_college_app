import "package:flutter/material.dart";
import "package:introduction_screen/introduction_screen.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:tm_college_app/widgets/change_dates_settings.dart';
import 'package:tm_college_app/widgets/fade_gradient.dart';
import "../models/notifications.dart";
import "./one_time_introduction_notifications_setting_tile.dart";

class OneTimeIntroductionScreen extends StatefulWidget {
  final Notifications notifications;

  final SharedPreferences sharedPreferences;

  OneTimeIntroductionScreen({
    @required this.notifications,
    @required this.sharedPreferences,
  });

  @override
  _OneTimeIntroductionScreenState createState() =>
      _OneTimeIntroductionScreenState();
}

class _OneTimeIntroductionScreenState extends State<OneTimeIntroductionScreen> {
  bool _show = false;

  void _showDoneButton({@required bool show}) {
    setState(() => _show = show);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      dotsFlex: 2,
      showDoneButton: _show,
      color: Colors.black,
      done: Text(
        "Terminé",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      onDone: () async {
        await widget.sharedPreferences.setBool("introductionSeen", true);
        Navigator.pushReplacementNamed(context, "/");
      },
      next: Icon(Icons.arrow_forward_rounded),
      dotsDecorator: DotsDecorator(
        color: Colors.grey,
        activeColor: Theme.of(context).primaryColor,
      ),
      pages: [
        PageViewModel(
            title: "Bienvenue dans Mon Année Scolaire !",
            image: Padding(
              padding: EdgeInsets.only(top: 50),
              child: Image.asset(
                "assets/images/transparent_icon.png",
              ),
            ),
            decoration: PageDecoration(
              bodyFlex: 1,
              imageFlex: 2,
            ),
            bodyWidget: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 12,
              child: FadeGradient(
                child: SingleChildScrollView(
                  child: Text(
                      "Une application simple et efficace pour gérer tes notes et devoirs.",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center),
                ),
              ),
            )),
        PageViewModel(
          decoration: PageDecoration(
            bodyFlex: 6,
            imageFlex: 5,
          ),
          title: "Avant de continuer",
          image: Icon(
            Icons.emoji_people_rounded,
            size: 200,
            color: Colors.orangeAccent,
          ),
          bodyWidget: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 3,
            child: FadeGradient(
              child: SingleChildScrollView(
                child: Text(
                    "Cette application a été conçue dans la cadre d'un travail de maturité à Genève. Certaines fonctionnalités sont donc restreintes au fonctionnement suisse.\n\nExemple : Les notes rentrées doivent être comprises entre 1,5 et 6. Les moyennes sont calculées selon le système des collèges de Genève, à savoir :\n\nMoyenne = (Moyenne du premier semestre arrondie au dixième + Moyenne du deuxième semestre arrondie au dixième) / 2\n\nL'expérience de l'application sur un autre appareil qu'un smartphone peut être détérirorée.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
        PageViewModel(
          decoration: PageDecoration(
            bodyFlex: 6,
            imageFlex: 5,
          ),
          title: "Activer les notifications ?",
          image: Icon(
            Icons.edit_notifications_rounded,
            size: 200,
            color: Theme.of(context).primaryColor,
          ),
          bodyWidget: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              children: [
                OneTimeIntroductionNotificationsSettingTile(
                  sharedPreferences: widget.sharedPreferences,
                  notifications: widget.notifications,
                ),
                Expanded(
                  child: FadeGradient(
                    child: SingleChildScrollView(
                      child: Text(
                          "Les notifications t'avertissent de devoirs à venir aux heures qui te conviennent.\n\nElles sont désactivables et personnalisables dans les paramètres.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
          decoration: PageDecoration(
            bodyFlex: 6,
            imageFlex: 5,
          ),
          title: "Un peu de configuration",
          image: Icon(
            Icons.date_range_rounded,
            size: 200,
            color: Theme.of(context).primaryColor,
          ),
          bodyWidget: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              children: [
                ChangeDatesSettings(
                  sharedPreferences: widget.sharedPreferences,
                  showDoneButtonFunction: _showDoneButton,
                ),
                Expanded(
                  child: FadeGradient(
                    child: SingleChildScrollView(
                      child: Text(
                          "Entre les dates qui délimitent ton semestre pour terminer la configuration.\n\nSi tu n'es pas sûr, tu pourras toujours modifier ces dates dans les paramètres.",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
