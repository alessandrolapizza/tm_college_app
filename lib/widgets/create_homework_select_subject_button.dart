import "package:flutter/material.dart";
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
    return OutlinedButton(
      onPressed: () => selectSubjectFunction(),
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
                    CircleAvatar(
                      backgroundColor: selectedSubject.couleurMatiere,
                      child: Icon(
                        selectedSubject.iconMatiere,
                        color: Colors.white,
                        size: 20,
                      ),
                      radius: 15,
                    ),
                    Text(" " + selectedSubject.nom),
                  ],
      ),
    );
  }
}
