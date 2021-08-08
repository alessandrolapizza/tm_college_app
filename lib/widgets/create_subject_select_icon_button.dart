import "package:flutter/material.dart";

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
    return OutlinedButton(
      onPressed: () => selectIconFunction(context),
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
      style: ButtonStyle(
        foregroundColor:
            iconMissing ? MaterialStateProperty.all(Colors.red) : null,
        side: iconMissing
            ? MaterialStateProperty.all(
                BorderSide(color: Colors.red),
              )
            : null,
      ),
    );
  }
}
