import "package:flutter/material.dart";

class ModularFloatingActionButton extends StatelessWidget {
  final Function onPressedFunction;

  final IconData icon;

  ModularFloatingActionButton({
    @required this.onPressedFunction,
    @required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => onPressedFunction(),
      child: Icon(icon),
    );
  }
}
