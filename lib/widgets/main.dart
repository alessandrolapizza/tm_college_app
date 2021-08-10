import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import "./app.dart";
import '../models/base_de_donnees.dart';

BaseDeDonnees database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  database = BaseDeDonnees();

  await database.defCheminMatieres();

  Intl.defaultLocale = "fr";

  runApp(App(database: database));
}
