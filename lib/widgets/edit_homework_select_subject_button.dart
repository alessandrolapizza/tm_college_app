import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/circle_avatar_with_border.dart';
import 'package:tm_college_app/widgets/modular_outlined_button.dart';
import "../models/matiere.dart";

class EditHomeworkSelectSubjectButton extends StatelessWidget {
  final Function selectSubjectFunction;

  final Matiere selectedSubject;

  EditHomeworkSelectSubjectButton({
    @required this.selectSubjectFunction,
    @required this.selectedSubject,
  });

  @override
  Widget build(BuildContext context) {
    return ModularOutlinedButton(
      onPressedFunction: selectSubjectFunction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            selectedSubject == null || selectedSubject == Matiere.noSubject
                ? [
                    Text("Matière "),
                    Icon(
                      Icons.table_rows_rounded,
                      size: 20,
                    ),
                  ]
                : [
                    Icon(selectedSubject.iconMatiere),
                    Text(" " + selectedSubject.nom),
                  ],
      ),
    );
  }
}
