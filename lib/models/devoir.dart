import "package:flutter/material.dart";

import "./matiere.dart";

class Devoir {
  final String contenu;
  final int id;
  final DateTime dateLimite;
  final Matiere matiere;
  final int importance;

  static const List<Color> listeCouleurImportance = [
    Colors.white,
    Colors.lightGreen,
    Colors.orange,
    Colors.red,
  ];

  static const List<String> listeTexteImportance = [
    "Indifférent",
    "Normal",
    "Moyen",
    "Urgent",
  ];

  Devoir({
    @required this.contenu,
    @required this.id,
    @required this.dateLimite,
    this.matiere,
    this.importance,
  });
}
