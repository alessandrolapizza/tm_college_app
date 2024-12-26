import "package:flutter/material.dart";
import "./modular_outlined_button.dart";
import "../models/subject.dart";

class EditHomeworkSelectSubjectButton extends StatelessWidget {
  final Function selectSubjectFunction;

  final Subject? selectedSubject;

  EditHomeworkSelectSubjectButton({
    required this.selectSubjectFunction,
    required this.selectedSubject,
  });

  @override
  Widget build(BuildContext context) {
    return ModularOutlinedButton(
      onPressedFunction: () => selectSubjectFunction(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
            selectedSubject == null || selectedSubject == Subject.noSubject
                ? [
                    Text("Matière "),
                    Icon(
                      Icons.table_rows_rounded,
                      size: 20,
                    ),
                  ]
                : [
                    Icon(selectedSubject!.icon),
                    Text(" " + selectedSubject!.name!),
                  ],
      ),
    );
  }
}
