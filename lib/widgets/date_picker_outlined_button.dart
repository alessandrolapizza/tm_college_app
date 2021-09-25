import "package:flutter/material.dart";

class DatePickerOutlinedButton extends StatelessWidget {
  final bool enabled;

  final String text;

  final Function function;

  DatePickerOutlinedButton({
    @required this.enabled,
    @required this.text,
    @required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: OutlinedButton(
        style: ButtonStyle(
          side: !enabled
              ? MaterialStateProperty.all(
                  BorderSide(color: Colors.grey),
                )
              : null,
          foregroundColor:
              !enabled ? MaterialStateProperty.all(Colors.grey) : null,
        ),
        onPressed: () => enabled ? function() : null,
        child: FittedBox(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text + " "),
              Icon(Icons.date_range_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
