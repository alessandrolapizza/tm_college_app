import "package:flutter/foundation.dart";

import "matiere.dart";

class Devoir {
  String titre;
  int id;
  DateTime dateLimite;
  Matiere matiere;

  Devoir({
    @required this.titre,
    @required this.id,
    @required this.dateLimite,
    this.matiere,
  });
}
