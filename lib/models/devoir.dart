import "package:flutter/foundation.dart";

import "matiere.dart";

class Devoir {
  String contenu;
  int id;
  DateTime dateLimite;
  Matiere matiere;
  int importance;

  Devoir({
    @required this.contenu,
    @required this.id,
    @required this.dateLimite,
    this.matiere,
    this.importance,
  });
}
