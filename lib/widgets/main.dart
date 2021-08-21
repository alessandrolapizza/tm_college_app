import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:tm_college_app/models/notifications.dart';
import "./app.dart";
import '../models/base_de_donnees.dart';
import "package:flutter/services.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  BaseDeDonnees database = BaseDeDonnees();

  await database.defCheminMatieres();

  Intl.defaultLocale = "fr";

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  SharedPreferences prefs = await SharedPreferences.getInstance();

  Notifications notifications = Notifications(
    sharedPreferences: prefs,
    database: database,
  );

  await notifications.configureLocalTimeZone();

  await notifications.initializePlugin();

  runApp(
    App(
      database: database,
      sharedPreferences: prefs,
      notifications: notifications,
    ),
  );
}
