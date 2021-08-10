import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/circle_avatar_with_border.dart';
import 'package:tm_college_app/widgets/modular_outlined_button.dart';
import "../models/matiere.dart";

class CreateHomeworkSelectSubjectButton extends StatelessWidget {
  final Function selectSubjectFunction;

  final Matiere selectedSubject;

  CreateHomeworkSelectSubjectButton({
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
                      Icons.school_rounded,
                      size: 20,
                    ),
                  ]
                : [
                    FractionallySizedBox(
                      heightFactor: 0.75,
                      child: CircleAvatarWithBorder(
                        color: selectedSubject.couleurMatiere,
                        icon: selectedSubject.iconMatiere,
                      ),
                    ),
                    Text(" " + selectedSubject.nom),
                  ],
      ),
    );
  }
}
