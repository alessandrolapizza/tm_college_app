import "package:flutter/material.dart";
import 'package:numberpicker/numberpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvancedNotificationsSettingsDayNumberPicker extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final int notificationsPriorityNumber;

  AdvancedNotificationsSettingsDayNumberPicker({
    @required this.sharedPreferences,
    @required this.notificationsPriorityNumber,
  });

  @override
  _AdvancedNotificationsSettingsDayNumberPickerState createState() =>
      _AdvancedNotificationsSettingsDayNumberPickerState();
}

class _AdvancedNotificationsSettingsDayNumberPickerState
    extends State<AdvancedNotificationsSettingsDayNumberPicker> {
  @override
  Widget build(BuildContext context) {
    return NumberPicker(
      haptics: true,
      minValue: 0,
      maxValue: 5,
      value: widget.sharedPreferences
              .getInt(widget.notificationsPriorityNumber == 0
                  ? "notificationsPriorityNumberWhite"
                  : widget.notificationsPriorityNumber == 1
                      ? "notificationsPriorityNumberGreen"
                      : widget.notificationsPriorityNumber == 2
                          ? "notificationsPriorityNumberOrange"
                          : "notificationsPriorityNumberRed") ??
          (widget.notificationsPriorityNumber == 0
              ? 0
              : widget.notificationsPriorityNumber == 1
                  ? 1
                  : widget.notificationsPriorityNumber == 2
                      ? 3
                      : 5),
      onChanged: (number) async => await widget.sharedPreferences
          .setInt(
              widget.notificationsPriorityNumber == 0
                  ? "notificationsPriorityNumberWhite"
                  : widget.notificationsPriorityNumber == 1
                      ? "notificationsPriorityNumberGreen"
                      : widget.notificationsPriorityNumber == 2
                          ? "notificationsPriorityNumberOrange"
                          : "notificationsPriorityNumberRed",
              number)
          .then((_) => setState(() {})),
      infiniteLoop: true,
    );
  }
}
