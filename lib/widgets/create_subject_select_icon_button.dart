import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/modular_outlined_button.dart';

class CreateSubjectSelectIconButton extends StatelessWidget {
  final Function selectIconFunction;

  final IconData selectedIcon;

  final bool iconMissing;

  CreateSubjectSelectIconButton({
    @required this.selectIconFunction,
    @required this.selectedIcon,
    @required this.iconMissing,
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
            selectedIcon == null ? Icons.edit : selectedIcon,
            size: 20,
          ),
        ],
      ),
    );
  }
}
