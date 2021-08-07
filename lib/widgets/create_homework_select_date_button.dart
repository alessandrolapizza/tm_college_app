import "package:flutter/material.dart";

import "package:intl/intl.dart";

class CreateHomeworkSelectDateButton extends StatelessWidget {
  final Function selectDateFunction;

  final DateTime selectedDate;

  CreateHomeworkSelectDateButton({
    @required this.selectDateFunction,
    @required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
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
