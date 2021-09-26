import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:tm_college_app/models/grade.dart';
import 'package:tm_college_app/widgets/modular_icon_button.dart';

class GradeDetailsCard extends StatelessWidget {
  final Grade grade;

  final Function editGradeFunction;

  final Function deleteGradeFunction;

  GradeDetailsCard({
    @required this.grade,
    @required this.editGradeFunction,
    @required this.deleteGradeFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 40,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    DateFormat("d.MM.y").format(grade.date),
                  ),
                  Text(
                    grade.grade.toString(),
                    style: TextStyle(color: Grade.color(average: grade.grade)),
                  ),
                  Text("coeff. ${grade.coefficient}"),
                ],
              ),
            ),
            Row(
              children: [
                ModularIconButton(
                  icon: Icons.edit_rounded,
                  onPressedFunction: () => editGradeFunction(grade: grade),
                ),
                ModularIconButton(
                  icon: Icons.delete_rounded,
                  onPressedFunction: deleteGradeFunction,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
