import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:tm_college_app/models/notifications.dart';
import "./app.dart";
import '../models/my_database.dart';
import "package:flutter/services.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MyDatabase database = MyDatabase();

  await database.defineDatabasePath();

  Intl.defaultLocale = "fr";

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  Notifications notifications = Notifications(
    sharedPreferences: sharedPreferences,
    database: database,
  );

  await notifications.configureLocalTimeZone();

  await notifications.initializePlugin();

  runApp(
    App(
      database: database,
      sharedPreferences: sharedPreferences,
      notifications: notifications,
    ),
  );
}
