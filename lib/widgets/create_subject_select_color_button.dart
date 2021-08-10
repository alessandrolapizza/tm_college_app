import "package:flutter/material.dart";
import "package:flutter_material_color_picker/flutter_material_color_picker.dart";
import 'package:tm_college_app/widgets/modular_outlined_button.dart';

class CreateSubjectSelectColorButton extends StatelessWidget {
  final Function selectColor;

  final Color selectedColor;

  final bool colorMissing;

  CreateSubjectSelectColorButton({
    @required this.selectColor,
    @required this.selectedColor,
    @required this.colorMissing,
  });

  @override
  Widget build(BuildContext context) {
    return ModularOutlinedButton(
      missingObject: colorMissing,
      onPressedFunction: selectColor,
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
