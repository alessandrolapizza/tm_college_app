import "package:flutter/material.dart";
import 'package:settings_ui/settings_ui.dart';

class ModularSettingsTile extends AbstractSettingsTile {
  final Widget? leading;

  final String? description;

  final String title;

  final String? value;

  final bool? hideArrow;

  final Function? onPressedFunction;

  final bool enabled;

  final Color? color;

  ModularSettingsTile({
    required this.title,
    this.leading,
    this.color,
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
      onPressed: onPressedFunction == null ? null : (_) => onPressedFunction!(),
      trailing: value == null
          ? hideArrow == null
              ? Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 15,
                  color: Colors.grey,
                )
              : hideArrow!
                  ? null
                  : Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.grey,
                    )
          : null,
      leading: leading == null ? null : leading,
      description: description == null
          ? null
          : Text(
              description!,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
      title: value == null
          ? Text(
              title,
              style: TextStyle(color: color),
            )
          : Container(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: color),
                  ),
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
