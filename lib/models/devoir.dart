import "package:flutter/material.dart";

import "./matiere.dart";

class Devoir {
  final String contenu;
  final int id;
  final DateTime dateLimite;
  final Matiere matiere;
  final int importance;

  static const listeCouleurImportance = [
    Colors.white,
    Colors.lightGreen,
    Colors.orange,
    Colors.red,
  ];

  Devoir({
    @required this.contenu,
    @required this.id,
    @required this.dateLimite,
    this.matiere,
    this.importance,
  });
}
