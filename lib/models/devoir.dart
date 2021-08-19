import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import "../models/base_de_donnees.dart";

import "./matiere.dart";

class Devoir {
  final String id;
  final String subjectId;
  final Matiere subject;
  final String content;
  final DateTime dueDate;
  final int priority;
  final bool done;
  final List<dynamic> notificationsIds;

  Devoir({
    @required this.subjectId,
    @required this.content,
    @required this.dueDate,
    @required this.priority,
    @required this.done,
    @required this.notificationsIds,
    this.subject,
    id,
  }) : id = id == null ? Uuid().v1() : id;

  Map<String, dynamic> toMapDb() {
    return {
      "id": id,
      "subjectId": subjectId,
      "content": content,
      "dueDate": dueDate.toString(),
      "priority": priority,
      "done": done ? 1 : 0,
      "notificationsIds": notificationsIds.toString(),
    };
  }

  static const Map<String, Color> priorityColorMap = {
    "Indifférente": Colors.white,
    "Normale": Colors.lightGreen,
    "Moyenne": Colors.orange,
    "Urgente": Colors.red,
  };

  static Future<void> homeworkChecker({
    @required Devoir homework,
    @required BaseDeDonnees db,
  }) async {
    Devoir checkedHomework = Devoir(
      done: homework.done ? false : true,
      content: homework.content,
      dueDate: homework.dueDate,
      priority: homework.priority,
      subjectId: homework.subjectId,
      subject: homework.subject,
      id: homework.id,
      notificationsIds: homework.notificationsIds,
    );

    await db.updateHomework(checkedHomework);
  }
}
