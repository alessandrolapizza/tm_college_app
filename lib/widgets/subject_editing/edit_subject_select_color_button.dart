import "package:flutter_material_color_picker/flutter_material_color_picker.dart";
import "package:flutter/material.dart";
import "../modular_outlined_button.dart";

class EditSubjectSelectColorButton extends StatelessWidget {
  final Function selectColor;

  final Color? selectedColor;

  final bool colorMissing;

  EditSubjectSelectColorButton({
    required this.selectColor,
    required this.selectedColor,
    required this.colorMissing,
  });

  @override
  Widget build(BuildContext context) {
    return ModularOutlinedButton(
      missingObject: colorMissing,
      onPressedFunction: () => selectColor(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Couleur "),
          selectedColor == null
              ? Icon(
                  Icons.edit_rounded,
                  size: 20,
                )
              : CircleColor(
                  color: selectedColor!,
                  circleSize: 20,
                ),
        ],
      ),
    );
  }
}
