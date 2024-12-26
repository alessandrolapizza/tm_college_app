import "package:flutter/material.dart";
import "./theme_controller.dart";

class ModularAlertDialog extends StatelessWidget {
  final List<Widget>? actionButtons;

  final Color? themeColor;

  final Widget? title;

  final Widget? content;

  ModularAlertDialog({
    required this.themeColor,
    this.actionButtons,
    this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: actionButtons == null
          ? [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ]
          : actionButtons,
    );
  }
}
