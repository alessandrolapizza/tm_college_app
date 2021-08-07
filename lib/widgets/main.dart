import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:tm_college_app/widgets/create_homework_page.dart';
import 'package:tm_college_app/widgets/create_subject_page.dart';
import 'package:tm_college_app/widgets/view_homework_page.dart';
import "./home_page.dart";

import "./page_visualiser_matiere.dart";
import '../models/base_de_donnees.dart';

BaseDeDonnees bD;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bD = BaseDeDonnees();

  await bD.defCheminMatieres();

  Intl.defaultLocale = "fr";

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        Locale(
          "fr",
          "FR",
        ),
      ],
      title: "TM_COLLEGE_APP", //Provisoire
      initialRoute: "/",
      routes: {
        "/": (_) => HomePage(bD),
        "/create_subject_page": (_) => CreateSubjectPage(bD),
        "/create_homework_page": (_) => CreateHomeworkPage(bD),
        "/page_visualiser_matiere": (_) => PageVisualiserMatiere(),
        "/homework_details_page": (_) => ViewHomeworkPage(),
      },
    );
  }
}
