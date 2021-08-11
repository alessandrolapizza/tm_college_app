import "package:flutter/material.dart";

class ModularIconButton extends StatelessWidget {
  final IconData icon;

  final Function onPressedFunction;

  final Color color;

  ModularIconButton({
    @required this.icon,
    @required this.onPressedFunction,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressedFunction,
      icon: Icon(icon),
      splashRadius: 20,
      color: color,
    );
  }
}
