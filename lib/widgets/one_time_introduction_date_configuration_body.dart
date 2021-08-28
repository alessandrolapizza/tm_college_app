import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/widgets/date_picker_outlined_button.dart';

class OneTimeIntroductionDateConfigurationBody extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final Function confirmDateConfigurationFunction;

  OneTimeIntroductionDateConfigurationBody({
    @required this.sharedPreferences,
    @required this.confirmDateConfigurationFunction,
  });

  @override
  _OneTimeIntroductionDateConfigurationBodyState createState() =>
      _OneTimeIntroductionDateConfigurationBodyState();
}

class _OneTimeIntroductionDateConfigurationBodyState
    extends State<OneTimeIntroductionDateConfigurationBody> {
  DateTime _selectedFirstTermBeginingDate;

  DateTime _selectedSecondTermBeginingDate;

  DateTime _selectedSecondTermEndDate;

  void _selectFirstTermBeginingDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: _selectedFirstTermBeginingDate == null
          ? DateTime.now()
          : _selectedFirstTermBeginingDate,
      firstDate: DateTime(DateTime.now().year),
      lastDate: _selectedSecondTermBeginingDate != null
          ? _selectedSecondTermBeginingDate.subtract(
              Duration(days: 1),
            )
          : DateTime(DateTime.now().year + 1, 12, 29),
    );
    if (date != null) {
      await widget.sharedPreferences
          .setString("firstTermBeginingDate", date.toString());
      setState(() => _selectedFirstTermBeginingDate = date);
    }
  }

  void _selectSecondTermBeginingDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: _selectedSecondTermBeginingDate == null
          ? DateTime.parse(
              widget.sharedPreferences.getString("firstTermBeginingDate"),
            ).add(
              Duration(days: 1),
            )
          : _selectedSecondTermBeginingDate,
      firstDate: DateTime.parse(
        widget.sharedPreferences.getString("firstTermBeginingDate"),
      ).add(
        Duration(days: 1),
      ),
      lastDate: _selectedSecondTermEndDate != null
          ? _selectedSecondTermEndDate.subtract(
              Duration(days: 1),
            )
          : DateTime(DateTime.now().year + 1, 12, 30),
    );
    if (date != null) {
      await widget.sharedPreferences
          .setString("secondTermBeginingDate", date.toString());
      setState(() => _selectedSecondTermBeginingDate = date);
    }
  }

  void _selectSecondTermEndDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: _selectedSecondTermEndDate == null
          ? DateTime.parse(
              widget.sharedPreferences.getString("secondTermBeginingDate"),
            ).add(
              Duration(days: 1),
            )
          : _selectedSecondTermEndDate,
      firstDate: DateTime.parse(
        widget.sharedPreferences.getString("secondTermBeginingDate"),
      ).add(
        Duration(days: 1),
      ),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
    );
    if (date != null) {
      await widget.sharedPreferences
          .setString("secondTermEndDate", date.toString());
      widget.confirmDateConfigurationFunction(show: true);
      setState(() => _selectedSecondTermEndDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DatePickerOutlinedButton(
          enabled: true,
          text: _selectedFirstTermBeginingDate != null
              ? "Début du premier semestre ${DateFormat("d/MM/y").format(_selectedFirstTermBeginingDate)}"
              : "Début du premier semestre",
          function: _selectFirstTermBeginingDate,
        ),
        DatePickerOutlinedButton(
          enabled: _selectedFirstTermBeginingDate != null,
          text: _selectedSecondTermBeginingDate != null
              ? "Début du deuxième semestre ${DateFormat("d/MM/y").format(_selectedSecondTermBeginingDate)}"
              : "Début du deuxième semestre",
          function: _selectSecondTermBeginingDate,
        ),
        DatePickerOutlinedButton(
          enabled: _selectedSecondTermBeginingDate != null,
          text: _selectedSecondTermEndDate != null
              ? "Fin du deuxième semestre ${DateFormat("d/MM/y").format(_selectedSecondTermEndDate)}"
              : "Fin du deuxième semestre",
          function: _selectSecondTermEndDate,
        ),
      ],
    );
  }
}
