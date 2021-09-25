import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/grade.dart';
import 'package:tm_college_app/widgets/grade_details_card.dart';
import 'package:tm_college_app/widgets/modular_sticky_header.dart';

class GradesList extends StatelessWidget {
  final Map<DateTime, List<Grade>> gradesSortedSubjectSpecific;

  final SharedPreferences sharedPreferences;

  final Function editGradeFunction;

  final Function deleteGradeFunction;

  final ScrollController gradesScrollController;

  GradesList({
    @required this.gradesSortedSubjectSpecific,
    @required this.sharedPreferences,
    @required this.deleteGradeFunction,
    @required this.editGradeFunction,
    @required this.gradesScrollController,
  });

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<Grade>> firstSemester = {};
    Map<DateTime, List<Grade>> secondSemester = {};
    gradesSortedSubjectSpecific.forEach((date, grades) {
      print(date);
      if (date.isBefore(DateTime.parse(
          sharedPreferences.getString("secondTermBeginingDate")))) {
        firstSemester[date] = grades;
      } else {
        secondSemester[date] = grades;
      }
    });
    List<Map<DateTime, List<Grade>>> semesterGrades = [
      firstSemester,
      secondSemester,
    ];
    return ListView.builder(
      itemCount: secondSemester.keys.length == 0 ? 1 : 2,
      controller: gradesScrollController,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (_, index) {
        return ModularStickyHeader(
          content: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: semesterGrades[index].keys.length,
            itemBuilder: (_, idx) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: semesterGrades[index]
                        [semesterGrades[index].keys.toList()[idx]]
                    .length,
                itemBuilder: (_, i) {
                  return GradeDetailsCard(
                      editGradeFunction: editGradeFunction,
                      deleteGradeFunction: () => deleteGradeFunction(
                          gradeId: semesterGrades[index]
                                  [semesterGrades[index].keys.toList()[idx]][i]
                              .id,
                          lastGrade: gradesSortedSubjectSpecific[
                                          gradesSortedSubjectSpecific.keys
                                              .toList()[0]]
                                      .length ==
                                  1 &&
                              gradesSortedSubjectSpecific.keys.length == 1),
                      grade: semesterGrades[index]
                          [semesterGrades[index].keys.toList()[idx]][i]);
                },
              );
            },
          ),
          header: Text(index == 0
              ? "Notes du premier semestre"
              : "Notes du deuxième semestre"),
          show: semesterGrades[index].keys.length != 0,
        );
      },
    );
  }
}
