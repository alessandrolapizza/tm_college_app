import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:sortedmap/sortedmap.dart";
import 'package:tm_college_app/models/my_database.dart';
import "package:uuid/uuid.dart";
import "./subject.dart";

class Grade {
  final String id;
  final String? subjectId;
  final Subject? subject;
  final double? grade;
  final double? coefficient;
  final DateTime? date;

  Grade({
    required this.coefficient,
    required this.date,
    required this.grade,
    required this.subjectId,
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

  static Color? color({required average}) {
    if (average < 3) {
      return Colors.red[400];
    } else if (average < 4) {
      return Colors.orange[400];
    } else if (average < 5) {
      return Colors.lightGreen[400];
    } else {
      return Colors.green[400];
    }
  }

  static List<dynamic> gradesMaps({
    required List<Grade> grades,
    required SharedPreferences sharedPreferences,
  }) {
    Map<Subject?, List<Grade>> gradesSubjectsMap = {};
    Map<Subject?, Map<DateTime, List<Grade>>> gradesSorted = {};
    Map<Subject?, List<Map<DateTime, double>>> averages = {};

    grades.forEach(
      (Grade grade) {
        if (gradesSubjectsMap.containsKey(grade.subject)) {
          gradesSubjectsMap[grade.subject]!.add(grade);
        } else {
          gradesSubjectsMap[grade.subject] = [grade];
        }
      },
    );

    gradesSubjectsMap.keys.forEach(
      (subject) {
        SortedMap<Comparable<DateTime>, List<Grade>> gradesDatesMapSorted =
            SortedMap(Ordering.byKey());
        gradesSubjectsMap[subject]!.forEach(
          (Grade grade) {
            if (gradesDatesMapSorted.containsKey(DateTime.utc(
                grade.date!.year, grade.date!.month, grade.date!.day))) {
              gradesDatesMapSorted[DateTime.utc(
                      grade.date!.year, grade.date!.month, grade.date!.day)]!
                  .add(grade);
            } else {
              gradesDatesMapSorted[DateTime.utc(
                  grade.date!.year, grade.date!.month, grade.date!.day)] = [grade];
            }
          },
        );
        gradesSorted[subject] = gradesDatesMapSorted.cast();
      },
    );

    gradesSorted.keys.forEach(
      (subject) {
        gradesSorted[subject]!.keys.forEach(
          (DateTime date) {
            double grades = 0;
            double coefficients = 0;
            double secondSemesterGrades = 0;
            double secondSemesterCoefficients = 0;
            gradesSorted[subject]![date]!.forEach(
              (Grade grade) {
                if (date.isBefore(
                  DateTime.parse(
                    sharedPreferences.getString("secondTermBeginingDate")!,
                  ),
                )) {
                  grades += (grade.grade! * grade.coefficient!);
                  coefficients += grade.coefficient!;
                } else {
                  secondSemesterGrades += (grade.grade! * grade.coefficient!);
                  secondSemesterCoefficients += grade.coefficient!;
                }
              },
            );
            gradesSorted[subject]!.keys.forEach(
              (DateTime subDate) {
                if (subDate.isBefore(date)) {
                  gradesSorted[subject]![subDate]!.forEach(
                    //test
                    (Grade subGrade) {
                      if (subDate.isBefore(
                        DateTime.parse(
                          sharedPreferences.getString("secondTermBeginingDate")!,
                        ),
                      )) {
                        grades += (subGrade.grade! * subGrade.coefficient!);
                        coefficients += subGrade.coefficient!;
                      } else {
                        secondSemesterGrades +=
                            (subGrade.grade! * subGrade.coefficient!);
                        secondSemesterCoefficients += subGrade.coefficient!;
                      }
                    },
                  );
                }
              },
            );
            if (averages.containsKey(subject)) {
              averages[subject]!.add({
                date: secondSemesterCoefficients == 0
                    ? (grades / coefficients)
                    : coefficients == 0
                        ? (secondSemesterGrades / secondSemesterCoefficients)
                        : ((double.parse((grades / coefficients)
                                    .toStringAsFixed(1)) +
                                double.parse((secondSemesterGrades /
                                        secondSemesterCoefficients)
                                    .toStringAsFixed(1))) /
                            2)
              });
            } else {
              averages[subject] = [
                {
                  date: secondSemesterCoefficients == 0
                      ? (grades / coefficients)
                      : coefficients == 0
                          ? (secondSemesterGrades / secondSemesterCoefficients)
                          : ((double.parse((grades / coefficients)
                                      .toStringAsFixed(1)) +
                                  double.parse((secondSemesterGrades /
                                          secondSemesterCoefficients)
                                      .toStringAsFixed(1))) /
                              2)
                }
              ];
            }
          },
        );
      },
    );
    return [gradesSorted, averages];
  }

  static Future<List<Grade>> outGrades({
    required MyDatabase database,
    required SharedPreferences sharedPreferences,
    DateTime? firstTermBeginingDate,
    DateTime? secondTermEndingDate,
  }) async {
    List<Grade> outGrades = [];
    List<Grade> grades = await database.grades();
    grades.forEach(
      (grade) async {
        if (grade.date!.isBefore(firstTermBeginingDate == null
                ? DateTime.parse(
                    sharedPreferences.getString(
                      "firstTermBeginingDate",
                    )!,
                  )
                : firstTermBeginingDate) ||
            grade.date!.isAfter(
              secondTermEndingDate == null
                  ? DateTime.parse(
                      sharedPreferences.getString(
                        "secondTermEndingDate",
                      )!,
                    )
                  : secondTermEndingDate,
            )) {
          outGrades.add(grade);
        }
      },
    );
    return outGrades;
  }
}
