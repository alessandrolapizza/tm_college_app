import "package:flutter/material.dart";

class Matiere {
  final int id;
  final String nom;
  final String salle;
  final IconData iconMatiere;
  final Color couleurMatiere;

  Matiere({
    @required this.nom,
    @required this.iconMatiere,
    @required this.couleurMatiere,
    @required this.salle,
    this.id,
  });

  Map<String, dynamic> mapBD() {
    return {
      "id": id,
      "nom": nom,
      "iconMatiere": iconMatiere,
      "couleurMatiereValeur": couleurMatiere.value,
    };
  }
}
