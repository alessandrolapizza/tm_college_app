import "package:flutter/material.dart";

class CreateSubjectSelectIconButton extends StatelessWidget {
  final Function selectIconFunction;

  final IconData selectedIcon;

  CreateSubjectSelectIconButton({
    @required this.selectIconFunction,
    @required this.selectedIcon,
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
    );
  }
}
