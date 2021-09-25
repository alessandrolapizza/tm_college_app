import "package:flutter/material.dart";
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/one_time_introduction_date_configuration_body.dart';
import 'package:tm_college_app/widgets/one_time_introduction_notifications_setting_tile.dart';

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
        "Done",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      onDone: () async {
        await widget.sharedPreferences.setBool("introductionSeen", true);
        Navigator.pushReplacementNamed(context, "/");
      },
      next: Icon(Icons.arrow_forward),
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
              'assets/images/transparent_icon.png',
            ),
          ),
          decoration: PageDecoration(
            bodyFlex: 1,
            imageFlex: 2,
          ),
          useScrollView: true,
          body:
              "Une application simple et efficace pour gérer tes notes et devoirs.",
        ),
        PageViewModel(
          title: "Avant de continuer",
          image: Icon(
            Icons.emoji_people_rounded,
            size: 200,
            color: Colors.orangeAccent,
          ),
          body:
              "Cette application a été conçue dans la cadre d'un travail de maturité à Genève. Elle est donc pour l'instant restreinte au fonctionnement général de ses collèges.",
          useScrollView: true,
        ),
        PageViewModel(
          title: "Activer les notifications ?",
          image: Icon(
            Icons.edit_notifications_rounded,
            size: 200,
            color: Theme.of(context).primaryColor,
          ),
          body:
              "Les notifications te permettent de te rappeler de tes devoirs aux heures qui te conviennent. Elles sont désactivables et customisables à tout moment dans les paramètres.",
          useScrollView: true,
          footer: OneTimeIntroductionNotificationsSettingTile(
            sharedPreferences: widget.sharedPreferences,
            notifications: widget.notifications,
          ),
        ),
        PageViewModel(
          title: "Un peu de configuration",
          image: Icon(
            Icons.edit,
            size: 200,
            color: Theme.of(context).primaryColor,
          ),
          body:
              "Attention ! Les dates fournies ne sont plus modifiables après validation. Pour les changers il faudra \"Commencer une nouvelle Année Scolaire\" dans les paramètres.",
          useScrollView: true,
        ),
        PageViewModel(
          title: "Dates",
          image: Icon(
            Icons.date_range,
            size: 200,
            color: Theme.of(context).primaryColor,
          ),
          bodyWidget: OneTimeIntroductionDateConfigurationBody(
            sharedPreferences: widget.sharedPreferences,
            confirmDateConfigurationFunction: _showDoneButton,
          ),
          useScrollView: true,
        ),
      ],
    );
  }
}
