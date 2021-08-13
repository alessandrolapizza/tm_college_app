import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/theme_controller.dart';

class ModularAlertDialog extends StatelessWidget {
  final Widget actionButton;

  final Color themeColor;

  final Widget title;

  final Widget content;

  ModularAlertDialog({
    @required this.themeColor,
    this.actionButton,
    this.title,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      color: themeColor,
      child: AlertDialog(
        title: title,
        content: content,
        actions: actionButton == null
            ? [
                TextButton(
                  child: Text("Annuler"),
                  onPressed: () => Navigator.pop(context),
                ),
              ]
            : [
                TextButton(
                  child: Text("Annuler"),
                  onPressed: () => Navigator.pop(context),
                ),
                actionButton,
              ],
      ),
    );
  }
}
