import "package:flutter/material.dart";

class Matiere {
  final String nom;
  final int id;
  final Color couleurMatiere;
  final IconData iconMatiere;

  Matiere({
    @required this.nom,
    @required this.id,
    @required this.couleurMatiere,
    @required this.iconMatiere,
  });
}
