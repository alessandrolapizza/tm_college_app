import "dart:convert";
import "package:flutter/material.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
import "./grade.dart";
import "./homework.dart";
import "./notifications.dart";
import "./subject.dart";

class MyDatabase {
  Future<Database>? database;

  Future<void> defineDatabasePath() async {
    database = openDatabase(
      join(await getDatabasesPath(), "mon_annee_scolaire_database.db"),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE subjects(id TEXT, name TEXT, room TEXT, iconCode INTEGER, colorValue INTEGER)",
        );
        db.execute(
          "CREATE TABLE homeworks(id TEXT, subjectId TEXT, content TEXT, dueDate TEXT, priority INTEGER, done INTEGER, notificationsIds STRING)",
        );
        db.execute(
          "CREATE TABLE grades(id TEXT, subjectId TEXT, grade REAL, coefficient REAL, date TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> inserertSubject(Subject matiere) async {
    final db = (await database)!;
    await db.insert(
      "subjects",
      matiere.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertHomework(Homework homework) async {
    final db = (await database)!;
    await db.insert(
      "homeworks",
      homework.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertGrade(Grade grade) async {
    final db = (await database)!;
    await db.insert(
      "grades",
      grade.toMapDb(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Subject>> subjects() async {
    final Database db = (await database)!;

    final List<Map<String, dynamic>> maps = await db.query("subjects");

    return List.generate(
      maps.length,
      (i) {
        return Subject(
          id: maps[i]["id"],
          name: maps[i]["name"],
          room: maps[i]["room"],
          icon: IconData(
            maps[i]["iconCode"],
            fontFamily: "MaterialIcons",
          ),
          color: Color(maps[i]["colorValue"]),
        );
      },
    );
  }

  Future<List<Homework>> homeworks() async {
    final db = (await database)!;

    Map<String, Subject> subjectsIdMaps = {
      Subject.noSubject.id: Subject.noSubject
    };

    final List<Map<String, dynamic>> homeworksMaps =
        await db.query("homeworks");

    final List<Subject> subjectsList = await subjects();

    subjectsList.forEach((subject) => subjectsIdMaps[subject.id] = subject);

    return List.generate(
      homeworksMaps.length,
      (i) {
        return Homework(
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

  Future<List<Grade>> grades() async {
    final db = (await database)!;

    Map<String, Subject> subjectsIdMaps = {};

    final List<Map<String, dynamic>> gradesMaps = await db.query("grades");

    final List<Subject> subjectsList = await subjects();

    subjectsList.forEach((subject) => subjectsIdMaps[subject.id] = subject);

    return List.generate(
      gradesMaps.length,
      (i) => Grade(
        id: gradesMaps[i]["id"],
        subjectId: gradesMaps[i]["subjectId"],
        subject: subjectsIdMaps[gradesMaps[i]["subjectId"]],
        coefficient: gradesMaps[i]["coefficient"],
        date: DateTime.parse(
          gradesMaps[i]["date"],
        ),
        grade: gradesMaps[i]["grade"],
      ),
    );
  }

  Future<void> updateSubject(Subject subject) async {
    final db = (await database)!;
    await db.update(
      "subjects",
      subject.toMapDb(),
      where: "id = ?",
      whereArgs: [subject.id],
    );
  }

  Future<void> updateHomework(Homework homework) async {
    final db = (await database)!;
    await db.update(
      "homeworks",
      homework.toMapDb(),
      where: "id = ?",
      whereArgs: [homework.id],
    );
  }

  Future<void> updateGrade(Grade grade) async {
    final db = (await database)!;
    await db.update(
      "grades",
      grade.toMapDb(),
      where: "id = ?",
      whereArgs: [grade.id],
    );
  }

  Future<void> deleteGrade(String id) async {
    final db = (await database)!;
    await db.delete(
      "grades",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteHomework({
    required Homework homework,
    required Notifications? notifications,
  }) async {
    final db = (await database)!;
    final String id = homework.id;
    if (homework.notificationsIds != null) {
      await notifications!
          .cancelMultipleNotifications(homework.notificationsIds!);
    }
    await db.delete(
      "homeworks",
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<void> deleteSubject({
    required Subject subject,
    required Notifications notifications,
  }) async {
    final db = (await database)!;

    final String id = subject.id;

    final List<Grade> gradesList = await grades();

    final List<Homework> homeworksList = await homeworks();

    gradesList.forEach(
      (Grade grade) async {
        if (grade.subjectId == subject.id) {
          await deleteGrade(grade.id);
        }
      },
    );

    homeworksList.forEach(
      (Homework homework) async {
        if (homework.subjectId == subject.id) {
          await deleteHomework(
            homework: homework,
            notifications: notifications,
          );
        }
      },
    );

    await db.delete(
      "subjects",
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
