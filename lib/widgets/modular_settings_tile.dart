import "package:flutter/material.dart";
import 'package:settings_ui/settings_ui.dart';

class ModularSettingsTile extends AbstractSettingsTile {
  final IconData icon;

  final String description;

  final String title;

  final String value;

  final bool hideArrow;

  final Function onPressedFunction;

  final bool enabled;

  ModularSettingsTile({
    @required this.icon,
    @required this.title,
    this.enabled = true,
    this.hideArrow,
    this.value,
    this.description,
    this.onPressedFunction,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      enabled: enabled,
      onPressed: onPressedFunction == null ? null : (_) => onPressedFunction(),
      trailing: value == null
          ? hideArrow == null
              ? Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: Colors.grey,
                )
              : hideArrow
                  ? null
                  : Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.grey,
                    )
          : null,
      leading: Icon(icon),
      description: description == null
          ? null
          : Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
      title: value == null
          ? Text(title)
          : Container(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Text(title),
                  Text(
                    "$value",
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
