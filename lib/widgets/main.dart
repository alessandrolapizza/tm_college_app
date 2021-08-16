import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import "./app.dart";
import '../models/base_de_donnees.dart';
import "package:flutter/services.dart";

BaseDeDonnees database;

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

  runApp(App(database: database));
}
