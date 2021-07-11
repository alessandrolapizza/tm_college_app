import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

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

  Map<String, dynamic> mapBD() {
    return {
      "id": id,
      "nom": nom,
      "salle": salle,
      "iconMatiereCode": iconMatiere.codePoint,
      "couleurMatiereValeur": couleurMatiere.value,
    };
  }
}
