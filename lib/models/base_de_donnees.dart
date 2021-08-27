import "package:flutter/material.dart";
import "dart:convert";

import "package:sqflite/sqflite.dart";
import "package:path/path.dart";
import 'package:tm_college_app/models/notifications.dart';

import "./matiere.dart";
import "./devoir.dart";

class BaseDeDonnees {
  Future<Database> database;

  Future<void> defCheminMatieres() async {
    database = openDatabase(
      join(await getDatabasesPath(), "matieres_basededonnees.db"), // à changer
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE matieres(id TEXT, nom TEXT, salle TEXT, iconMatiereCode INTEGER, couleurMatiereValeur INTEGER)",
        );
        db.execute(
          "CREATE TABLE homeworks(id TEXT, subjectId TEXT, content TEXT, dueDate TEXT, priority INTEGER, done INTEGER, notificationsIds STRING)",
        );
      },
      version: 1,
    );
  }

  Future<void> insererMatiere(Matiere matiere) async {
    final db = await database;
    await db.insert(
      "matieres",
      matiere.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertHomework(Devoir homework) async {
    final bD = await database;
    await bD.insert(
      "homeworks",
      homework.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Matiere>> matieres() async {
    final Database bD = await database;

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

  Future<List<Devoir>> homeworks() async {
    final db = await database;

    Map<String, Matiere> subjectsIdMaps = {
      Matiere.noSubject.id: Matiere.noSubject
    };

    final List<Map<String, dynamic>> homeworksMaps =
        await db.query("homeworks");

    final List<Matiere> subjectsList = await matieres();

    subjectsList.forEach((subject) => subjectsIdMaps[subject.id] = subject);

    return List.generate(
      homeworksMaps.length,
      (i) {
        return Devoir(
          id: homeworksMaps[i]["id"],
          subjectId: homeworksMaps[i]["subjectId"],
          subject: subjectsIdMaps[homeworksMaps[i]["subjectId"]],
          content: homeworksMaps[i]["content"],
          dueDate: DateTime.parse(
            homeworksMaps[i]["dueDate"],
          ),
          priority: homeworksMaps[i]["priority"],
          done: homeworksMaps[i]["done"] == 0 ? false : true,
          notificationsIds:
              json.decode(homeworksMaps[i]["notificationsIds"]) == null
                  ? null
                  : json
                      .decode(
                        homeworksMaps[i]["notificationsIds"],
                      )
                      .cast<int>(),
        );
      },
    );
  }

  Future<void> modifierMatiere(Matiere matiere) async {
    final db = await database;

    await db.update(
      "matieres",
      matiere.toMapDb(),
      where: "id = ?",
      whereArgs: [matiere.id],
    );
  }

  Future<void> updateHomework(Devoir homework) async {
    final db = await database;

    await db.update(
      "homeworks",
      homework.toMapDb(),
      where: "id = ?",
      whereArgs: [homework.id],
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

  Future<void> deleteHomework({
    @required Devoir homework,
    @required Notifications notifications,
  }) async {
    final db = await database;

    final String id = homework.id;

    if (homework.notificationsIds != null) {
      await notifications
          .cancelMultipleNotifications(homework.notificationsIds);
    }

    await db.delete(
      "homeworks",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
