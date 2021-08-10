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

const Map<int, Color> color = {
  50: Color(4283522728),
  100: Color(4283522728),
  200: Color(4283522728),
  300: Color(4283522728),
  400: Color(4283522728),
  500: Color(4283522728),
  600: Color(4283522728),
  700: Color(4283522728),
  800: Color(4283522728),
  900: Color(4283522728),
};

MaterialColor customMaterialColor = MaterialColor(4283522728, color);

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
      theme: ThemeData(
        primarySwatch: customMaterialColor,
      ),
    );
  }
}
