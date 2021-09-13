import "package:flutter/foundation.dart";
import 'package:tm_college_app/models/matiere.dart';
import 'package:uuid/uuid.dart';

class Grade {
  final String id;
  final String subjectId;
  final Matiere subject;
  final double grade;
  final double coefficent;
  final DateTime date;

  Grade({
    @required this.coefficent,
    @required this.date,
    @required this.grade,
    @required this.subject,
    @required this.subjectId,
    id,
  }) : id = id == null ? Uuid().v1() : id;
}
