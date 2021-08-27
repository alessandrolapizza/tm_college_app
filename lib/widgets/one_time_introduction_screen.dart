import "package:flutter/material.dart";
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/one_time_introduction_notifications_setting_tile.dart';

class OneTimeIntroductionScreen extends StatelessWidget {
  final Notifications notifications;

  final SharedPreferences sharedPreferences;

  OneTimeIntroductionScreen({
    @required this.notifications,
    @required this.sharedPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      color: Colors.black,
      done: Text(
        "Done",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      onDone: () async {
        await sharedPreferences.setBool("introductionSeen", true);
        Navigator.pushReplacementNamed(context, "/");
      },
      showNextButton: true,
      next: Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: Text("Passer"),
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
          body: "Une application simple et efficace pour gérer tes devoirs.",
        ),
        PageViewModel(
          title: "Activer les notifications ?",
          image: Icon(
            Icons.notifications,
            size: 100,
          ),
          bodyWidget: Column(
            children: [
              Text(
                "Les notifications te permettent de te rappeler de tes devoirs aux heures qui te conviennent. Elles sont désactivables et customisables à tout moment dans les paramètres de l'application.",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
              ),
              OneTimeIntroductionNotificationsSettingTile(
                sharedPreferences: sharedPreferences,
                notifications: notifications,
              )
            ],
          ),
          useScrollView: false,
        ),
      ],
    );
  }
}
