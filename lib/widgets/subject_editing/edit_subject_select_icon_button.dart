import "package:flutter/material.dart";
import "../modular_outlined_button.dart";

class EditSubjectSelectIconButton extends StatelessWidget {
  final Function selectIconFunction;

  final IconData? selectedIcon;

  final bool iconMissing;

  EditSubjectSelectIconButton({
    required this.selectIconFunction,
    required this.selectedIcon,
    required this.iconMissing,
  });

  @override
  Widget build(BuildContext context) {
    return ModularOutlinedButton(
      missingObject: iconMissing,
      onPressedFunction: () => selectIconFunction(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Icon "),
          Icon(
            selectedIcon == null ? Icons.edit_rounded : selectedIcon,
            size: 20,
          ),
        ],
      ),
    );
  }
}
