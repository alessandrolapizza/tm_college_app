import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import "../widgets/app.dart";

class Matiere {
  final String id;
  final String nom;
  final String salle;
  final IconData iconMatiere;
  final Color couleurMatiere;

  Matiere({
    @required this.nom,
    @required this.iconMatiere,
    @required this.couleurMatiere,
    @required this.salle,
    id,
  }) : id = id == null ? Uuid().v4() : id;

  static final noSubject = Matiere(
      id: "0",
      nom: "Divers",
      iconMatiere: Icons.more_horiz_rounded,
      couleurMatiere: App.toMaterialColor(App.defaultColorThemeValue),
      salle: "");

  Map<String, dynamic> toMapDb() {
    return {
      "id": id,
      "nom": nom,
      "salle": salle,
      "iconMatiereCode": iconMatiere.codePoint,
      "couleurMatiereValeur": couleurMatiere.value,
    };
  }
}
