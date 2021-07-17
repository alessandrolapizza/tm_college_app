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

  Devoir({
    @required this.subjectId,
    @required this.subject,
    @required this.content,
    @required this.dueDate,
    @required this.priority,
    id,
  }) : id = id == null ? Uuid().v4() : id;

  static const List<Color> listeCouleurImportance = [
    Colors.white,
    Colors.lightGreen,
    Colors.orange,
    Colors.red,
  ];

  static const List<String> listeTexteImportance = [
    "Indifférent",
    "Normal",
    "Moyen",
    "Urgent",
  ];
}
