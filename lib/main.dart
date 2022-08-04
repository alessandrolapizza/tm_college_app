import "package:flutter/material.dart";
import "package:intl/intl.dart";
import 'package:package_info_plus/package_info_plus.dart';
import "package:shared_preferences/shared_preferences.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "../widgets/app.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MyDatabase database = MyDatabase();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  await database.defineDatabasePath();

  Intl.defaultLocale = "fr";

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  Notifications notifications = Notifications(
    sharedPreferences: sharedPreferences,
    database: database,
  );

  await notifications.configureLocalTimeZone();

  await notifications.initializePlugin();

  runApp(
    App(
      packageInfo: packageInfo,
      database: database,
      sharedPreferences: sharedPreferences,
      notifications: notifications,
    ),
  );
}
