import "package:flutter/material.dart";

import "package:intl/intl.dart";

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
    return OutlinedButton(
      style: ButtonStyle(
        foregroundColor:
            dateMissing ? MaterialStateProperty.all(Colors.red) : null,
        side: dateMissing
            ? MaterialStateProperty.all(
                BorderSide(color: Colors.red),
              )
            : null,
      ),
      onPressed: () => selectDateFunction(),
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
