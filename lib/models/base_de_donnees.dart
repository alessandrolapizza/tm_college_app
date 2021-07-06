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
          "CREATE TABLE matieres(id INTEGER, nom TEXT, salle TEXT, iconMatiere TEXT, couleurMatiere TEXT)",
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

  Future<List<Matiere>> matieres() async {
    final bD = await baseDeDonneesMatieres;

    final List<Map<String, dynamic>> maps = await bD.query("matieres");

    return List.generate(
      maps.length,
      (i) {
        return Matiere(
          id: maps[i]["id"],
          nom: maps[i]["nom"],
          salle: maps[i]["salle"],
          iconMatiere: maps[i]["iconMatiere"],
          couleurMatiere: maps[i]["couleurMatiere"],
        );
      },
    );
  }

  Future<void> modifierMatiere(Matiere matiere) async {
    final bD = await baseDeDonneesMatieres;

    await bD.update(
      "matieres",
      matiere.toMap(),
      where: "id = ?",
      whereArgs: [matiere.id],
    );
  }

  Future<void> supprimerMatiere(int id) async {
    final bD = await baseDeDonneesMatieres;

    await bD.delete(
      "matieres",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
