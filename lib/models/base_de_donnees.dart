import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

import "./matiere.dart";

class BaseDeDonnees {
  var baseDeDonneesMatieres;

  void defCheminMatieres() async {
    baseDeDonneesMatieres = openDatabase(
      join(await getDatabasesPath(), "matieres_basededonnees.db"),
      onCreate: (bD, version) {
        return bD.execute(
          "CREATE TABLE matieres(id INTEGER, nom TEXT, iconMatiere BLOB, couleurMatiere BLOB)",
        );
      },
      version: 1,
    );
  }

  Future<void> insererMatiere(Matiere matiere) async {
    final bD = await baseDeDonneesMatieres;
    await bD.insert(
      "matieres",
      matiere.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
