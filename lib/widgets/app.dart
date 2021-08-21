import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/notifications.dart';

import 'package:tm_college_app/widgets/edit_homework_screen.dart';
import 'package:tm_college_app/widgets/create_subject_screen.dart';
import 'package:tm_college_app/widgets/done_homeworks_screen.dart';
import 'package:tm_college_app/widgets/one_time_introduction_screen.dart';
import 'package:tm_college_app/widgets/view_homework_screen.dart';
import 'package:tm_college_app/widgets/settings_screen.dart';
import 'home_screen.dart';
import "../models/base_de_donnees.dart";

import "./page_visualiser_matiere.dart";

class App extends StatelessWidget {
  final BaseDeDonnees database;

  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  App({
    @required this.database,
    @required this.sharedPreferences,
    @required this.notifications,
  });

  static final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver();

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
    return MaterialApp(
      navigatorObservers: [routeObserver],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        defaultLocale,
      ],
      title: "Mon année Scolaire", //Provisoire
      initialRoute: "/",
      routes: {
        "/": (_) => sharedPreferences.getBool("introductionSeen") ?? false
            ? HomeScreen(database)
            : OneTimeIntroductionScreen(
                notifications: notifications,
                sharedPreferences: sharedPreferences,
              ),
        "/create_subject_screen": (_) => CreateSubjectScreen(database),
        "/edit_homework_screen": (_) => EditHomeworkScreen(
              notifications: notifications,
              db: database,
            ),
        "/page_visualiser_matiere": (_) => PageVisualiserMatiere(),
        "/view_homework_screen": (_) => ViewHomeworkScreen(db: database),
        "/done_homeworks_screen": (_) => DoneHomeworksScreen(db: database),
        "/settings_screen": (_) => SettingsScreen(),
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
