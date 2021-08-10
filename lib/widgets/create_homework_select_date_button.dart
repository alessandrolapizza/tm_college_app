import "package:flutter/material.dart";

import "package:intl/intl.dart";
import 'package:tm_college_app/widgets/modular_outlined_button.dart';

class CreateHomeworkSelectDateButton extends StatelessWidget {
  final Function selectDateFunction;

  final DateTime selectedDate;

  final bool dateMissing;

  CreateHomeworkSelectDateButton({
    @required this.selectDateFunction,
    @required this.selectedDate,
    @required this.dateMissing,
  });

  @override
  Widget build(BuildContext context) {
    return ModularOutlinedButton(
      missingObject: dateMissing,
      onPressedFunction: selectDateFunction,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: selectedDate == null
            ? [
                Text("Date "),
                Icon(
                  Icons.date_range_rounded,
                  size: 20,
                ),
              ]
            : [
                Text(
                  DateFormat("EEE d MMMM").format(selectedDate),
                )
              ],
      ),
    );
  }
}
