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
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
      highlightElevation: 0,
      elevation: 0,
      onPressed: () => onPressedFunction(),
      child: Icon(icon),
    );
  }
}
