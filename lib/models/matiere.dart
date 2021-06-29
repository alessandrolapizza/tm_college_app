import "package:flutter/material.dart";

class Matiere {
  final String titre;
  final int id;
  final Color couleurMatiere;
  final Icons iconMatiere;

  Matiere({
    @required this.titre,
    @required this.id,
    @required this.couleurMatiere,
    @required this.iconMatiere,
  });
}
