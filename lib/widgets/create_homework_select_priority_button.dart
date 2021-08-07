import "package:flutter/material.dart";
import "package:flutter_material_color_picker/flutter_material_color_picker.dart";
import "../models/devoir.dart";

class CreateHomeworkSelectPriorityButton extends StatelessWidget {
  final Function selectPriorityFunction;

  final int selectedPriority;

  CreateHomeworkSelectPriorityButton({
    @required this.selectPriorityFunction,
    @required this.selectedPriority,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => selectPriorityFunction(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Importance "),
          selectedPriority == 0
              ? Icon(
                  Icons.format_list_numbered_rtl_rounded,
                  size: 20,
                )
              : CircleColor(
                  color:
                      Devoir.priorityColorMap.values.toList()[selectedPriority],
                  circleSize: 20),
        ],
      ),
    );
  }
}
