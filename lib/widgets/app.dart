import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tm_college_app/widgets/change_dates_settings_screen.dart';
import 'package:tm_college_app/widgets/changelog_screen.dart';
import "../models/my_database.dart";
import "../models/notifications.dart";
import "./advanced_notifications_settings_screen.dart";
import "./done_homeworks_screen.dart";
import "./edit_homework_screen.dart";
import "./edit_subject_screen.dart";
import "./home_screen.dart";
import "./one_time_introduction_screen.dart";
import "./settings_screen.dart";
import "./start_new_school_year_settings_screen.dart";
import "./view_average_screen.dart";
import "./view_homework_screen.dart";

class App extends StatelessWidget {
  final MyDatabase database;

  final SharedPreferences sharedPreferences;

  final Notifications notifications;

  final PackageInfo packageInfo;

  App({
    @required this.database,
    @required this.sharedPreferences,
    @required this.notifications,
    @required this.packageInfo,
  });

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

  static RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  upgrader() async {
    // String currentVersion =
    //    "${packageInfo.version}";
    if (sharedPreferences.getString("secondTermEndDate") != null) {
      await sharedPreferences.setString("secondTermEndingDate",
          sharedPreferences.getString("secondTermEndDate"));
      await sharedPreferences.remove("secondTermEndDate");
      await sharedPreferences.setString("upgraderVersion", packageInfo.version); //METTRE A DEUX, en string.
      await sharedPreferences.setBool("changelogSeen", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    upgrader();
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        defaultLocale,
      ],
      title: "Mon Année Scolaire",
      initialRoute: "/",
      routes: {
        "/": (_) => sharedPreferences.getBool("introductionSeen") ?? false
            ? sharedPreferences.getBool("changelogSeen") ?? false
                ? HomeScreen(
                    sharedPreferences: sharedPreferences,
                    database: database,
                    notifications: notifications,
                  )
                : ChangelogScreen(
                    sharedPreferences: sharedPreferences,
                    packageInfo: packageInfo,
                  )
            : OneTimeIntroductionScreen(
                notifications: notifications,
                sharedPreferences: sharedPreferences,
              ),
        "/edit_subject_screen": (_) => EditSubjectScreen(
              database: database,
              notifications: notifications,
            ),
        "/edit_homework_screen": (_) => EditHomeworkScreen(
              sharedPreferences: sharedPreferences,
              notifications: notifications,
              database: database,
            ),
        "/view_homework_screen": (_) => ViewHomeworkScreen(
              sharedPreferences: sharedPreferences,
              database: database,
              notifications: notifications,
            ),
        "/done_homeworks_screen": (_) => DoneHomeworksScreen(
              sharedPreferences: sharedPreferences,
              database: database,
              notifications: notifications,
            ),
        "/settings_screen": (_) => SettingsScreen(
              packageInfo: packageInfo,
              database: database,
              sharedPreferences: sharedPreferences,
              notifications: notifications,
            ),
        "/advanced_notifications_settings_screen": (_) =>
            AdvancedNotificationsSettingsScreen(
              notifications: notifications,
              sharedPreferences: sharedPreferences,
            ),
        "/view_grade_screen": (_) => ViewAverageScreen(
              database: database,
              sharedPreferences: sharedPreferences,
            ),
        "start_new_school_year_settings_screen": (_) =>
            StartNewSchoolYearSettingsScreen(
              sharedPreferences: sharedPreferences,
              database: database,
              notifications: notifications,
            ),
        "change_dates_settings_screen": (_) => ChangeDatesSettingsScreen(
              notifications: notifications,
              sharedPreferences: sharedPreferences,
              database: database,
            ),
      },
      theme: ThemeData(
        dialogBackgroundColor: Colors.grey[100],
        scaffoldBackgroundColor: Colors.grey[100],
        highlightColor: Colors.transparent,
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
