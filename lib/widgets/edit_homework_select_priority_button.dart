import "package:flutter_material_color_picker/flutter_material_color_picker.dart";
import "package:flutter/material.dart";
import "./modular_outlined_button.dart";
import "../models/homework.dart";

class EditHomeworkSelectPriorityButton extends StatelessWidget {
  final Function selectPriorityFunction;

  final int selectedPriority;

  EditHomeworkSelectPriorityButton({
    @required this.selectPriorityFunction,
    @required this.selectedPriority,
  });

  @override
  Widget build(BuildContext context) {
    return ModularOutlinedButton(
      onPressedFunction: selectPriorityFunction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Importance "),
          selectedPriority == 0
              ? Icon(
                  Icons.low_priority_rounded,
                  size: 20,
                )
              : CircleColor(
                  color: Homework.priorityColorMap.values
                      .toList()[selectedPriority],
                  circleSize: 20),
        ],
      ),
    );
  }
}
