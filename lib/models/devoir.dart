import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

import "./matiere.dart";

class Devoir {
  final String id;
  final String subjectId;
  final Matiere subject;
  final String content;
  final DateTime dueDate;
  final int priority;
  final bool done;

  Devoir({
    @required this.subjectId,
    @required this.content,
    @required this.dueDate,
    @required this.priority,
    @required this.done,
    this.subject,
    id,
  }) : id = id == null ? Uuid().v4() : id;

  Map<String, dynamic> toMapDb() {
    return {
      "id": id,
      "subjectId": subjectId,
      "content": content,
      "dueDate": dueDate.toString(),
      "priority": priority,
      "done": done ? 1 : 0,
    };
  }

  static const Map<String, Color> priorityColorMap = {
    "Indifférente": Colors.white,
    "Normale": Colors.lightGreen,
    "Moyenne": Colors.orange,
    "Urgente": Colors.red,
  };
}
