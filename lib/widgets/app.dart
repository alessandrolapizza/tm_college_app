import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter/services.dart";
import 'package:tm_college_app/widgets/create_homework_page.dart';
import 'package:tm_college_app/widgets/create_subject_page.dart';
import 'package:tm_college_app/widgets/view_homework_page.dart';
import "./home_page.dart";
import "../models/base_de_donnees.dart";

import "./page_visualiser_matiere.dart";

class App extends StatelessWidget {
  final BaseDeDonnees database;

  App({@required this.database});

  static const int defaultColorThemeValue = 4283522728;

  static MaterialColor toMaterialColor(int colorValue) {
    Map<int, Color> colorMap = {
      50: Color(colorValue),
      100: Color(colorValue),
      200: Color(colorValue),
      300: Color(colorValue),
      400: Color(colorValue),
      500: Color(colorValue),
      600: Color(colorValue),
      700: Color(colorValue),
      800: Color(colorValue),
      900: Color(colorValue),
    };
    return MaterialColor(colorValue, colorMap);
  }

  static const Locale defaultLocale = Locale("fr", "FR");

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
        defaultLocale,
      ],
      title: "TM_COLLEGE_APP", //Provisoire
      initialRoute: "/",
      routes: {
        "/": (_) => HomePage(database),
        "/create_subject_page": (_) => CreateSubjectPage(database),
        "/create_homework_page": (_) => CreateHomeworkPage(database),
        "/page_visualiser_matiere": (_) => PageVisualiserMatiere(),
        "/homework_details_page": (_) => ViewHomeworkPage(
              db: database,
            ),
      },
      theme: ThemeData(
        primarySwatch: toMaterialColor(defaultColorThemeValue),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
