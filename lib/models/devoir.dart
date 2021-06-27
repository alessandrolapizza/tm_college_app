import "package:flutter/foundation.dart";

import "matiere.dart";

class Devoir {
  String titre;
  int id;
  Matiere matiere;

  Devoir({
    @required this.titre,
    @required this.id,
    this.matiere,
  });
}
