import "package:flutter/foundation.dart";

import "./matiere.dart";

class Devoir {
  final String contenu;
  final int id;
  final DateTime dateLimite;
  final Matiere matiere;
  final int importance;

  Devoir({
    @required this.contenu,
    @required this.id,
    @required this.dateLimite,
    this.matiere,
    this.importance,
  });
}
