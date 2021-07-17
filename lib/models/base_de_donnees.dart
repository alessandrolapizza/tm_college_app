import "package:flutter/material.dart";

import "package:sqflite/sqflite.dart";
import "package:path/path.dart";

import "./matiere.dart";

class BaseDeDonnees {
  Future<Database> database;

  void defCheminMatieres() async {
    database = openDatabase(
      join(await getDatabasesPath(), "matieres_basededonnees.db"),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE matieres(id TEXT, nom TEXT, salle TEXT, iconMatiereCode INTEGER, couleurMatiereValeur INTEGER)",
        );
        db.execute(
          "CREATE TABLE homeworks(id TEXT, subjectId TEXT, content TEXT, dueDate TEXT, priority INTEGER)",
        );
      },
      version: 1,
    );
  }

  Future<void> insererMatiere(Matiere matiere) async {
    final bD = await database;
    await bD.insert(
      "matieres",
      matiere.mapBD(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Matiere>> matieres() async {
    final bD = await database;

    final List<Map<String, dynamic>> maps = await bD.query("matieres");

    return List.generate(
      maps.length,
      (i) {
        return Matiere(
          id: maps[i]["id"],
          nom: maps[i]["nom"],
          salle: maps[i]["salle"],
          iconMatiere: IconData(
            maps[i]["iconMatiereCode"],
            fontFamily: "MaterialIcons",
          ),
          couleurMatiere: Color(maps[i]["couleurMatiereValeur"]),
        );
      },
    );
  }

  Future<void> modifierMatiere(Matiere matiere) async {
    final bD = await database;

    await bD.update(
      "matieres",
      matiere.mapBD(),
      where: "id = ?",
      whereArgs: [matiere.id],
    );
  }

  Future<void> supprimerMatiere(int id) async {
    final bD = await database;

    await bD.delete(
      "matieres",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
