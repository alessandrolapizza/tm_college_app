import "package:flutter/material.dart";
import "package:flutter_material_color_picker/flutter_material_color_picker.dart";

class CreateSubjectSelectColorButton extends StatelessWidget {
  final Function selectColor;

  final Color selectedColor;

  CreateSubjectSelectColorButton({
    @required this.selectColor,
    @required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => selectColor(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Couleur "),
          selectedColor == null
              ? Icon(
                  Icons.edit,
                  size: 20,
                )
              : CircleColor(
                  color: selectedColor,
                  circleSize: 20,
                ),
        ],
      ),
    );
  }
}
