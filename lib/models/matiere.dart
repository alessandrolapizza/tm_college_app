import "package:flutter/material.dart";

class Matiere {
  final int id;
  final String nom;
  final IconData iconMatiere;
  final Color couleurMatiere;

  Matiere({
    @required this.nom,
    @required this.iconMatiere,
    @required this.couleurMatiere,
    this.id,
  });
}
