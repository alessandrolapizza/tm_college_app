import "package:flutter/foundation.dart";
import 'package:tm_college_app/models/matiere.dart';
import 'package:uuid/uuid.dart';

class Grade {
  final String id;
  final String subjectId;
  final Matiere subject;
  final double grade;
  final double coefficient;
  final DateTime date;

  Grade({
    @required this.coefficient,
    @required this.date,
    @required this.grade,
    @required this.subjectId,
    this.subject,
    id,
  }) : id = id == null ? Uuid().v1() : id;

  Map<String, dynamic> toMapDb() {
    return {
      "id": id,
      "subjectId": subjectId,
      "grade": grade,
      "coefficient": coefficient,
      "date": date.toString(),
    };
  }
}
