import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/models/grade.dart';
import 'package:tm_college_app/models/matiere.dart';
import 'package:tm_college_app/widgets/edit_grade_form.dart';
import 'package:tm_college_app/widgets/fade_gradient.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';
import 'package:tm_college_app/widgets/modular_outlined_button.dart';
import 'package:tm_college_app/widgets/theme_controller.dart';

class EditGradeDialog extends StatefulWidget {
  final List<Matiere> subjects;

  final SharedPreferences sharedPreferences;

  final BaseDeDonnees database;

  EditGradeDialog({
    @required this.subjects,
    @required this.sharedPreferences,
    @required this.database,
  });

  @override
  _EditGradeDialogState createState() => _EditGradeDialogState();
}

class _EditGradeDialogState extends State<EditGradeDialog> {
  final GlobalKey<FormState> _editGradeFormKey = GlobalKey();

  final TextEditingController _coefficientController =
      TextEditingController(text: "1");

  DateTime _selectedGradeDate;

  String _dropdownValue = "0";

  bool _gradeDateMissing = false;

  void _onChangedFuntion(value) {
    if (value != "0") {
      setState(() => _dropdownValue = value);
    }
  }

  Future<void> _selectGradeDate() async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().isAfter(
                DateTime.parse(
                  widget.sharedPreferences.getString("firstTermBeginingDate"),
                ),
              ) &&
              DateTime.now().isBefore(
                DateTime.parse(
                  widget.sharedPreferences.getString("secondTermEndDate"),
                ),
              )
          ? DateTime.now()
          : DateTime.parse(
              widget.sharedPreferences.getString("firstTermBeginingDate"),
            ),
      firstDate: DateTime.parse(
        widget.sharedPreferences.getString("firstTermBeginingDate"),
      ),
      lastDate: DateTime.parse(
        widget.sharedPreferences.getString("secondTermEndDate"),
      ),
    );
    if (date != null) {
      setState(() => _selectedGradeDate = date);
    }
  }

  _addGrade() {
    if (_editGradeFormKey.currentState.validate() &&
        _selectedGradeDate != null) {
      // widget.database.insertGrade(
      // Grade(
      //    coefficient: double.parse(_coefficientController.text),
      //     ),
      //    );
    } else if (_selectedGradeDate == null) {
      //print(double.parse(_coefficientController.text));

      setState(() => _gradeDateMissing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModularAlertDialog(
      content: ThemeController(
        color: Colors.black,
        child: FadeGradient(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EditGradeForm(
                  coefficientController: _coefficientController,
                  editGradeFormKey: _editGradeFormKey,
                  dropdownValue: _dropdownValue,
                  subjects: widget.subjects,
                  onChangedFunction: _onChangedFuntion,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                ),
                ModularOutlinedButton(
                  onPressedFunction: _selectGradeDate,
                  child: _selectedGradeDate == null
                      ? Text("Date")
                      : Text(
                          DateFormat("EEE d MMMM").format(_selectedGradeDate),
                        ),
                  missingObject: _gradeDateMissing,
                ),Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
              ],
            ),
          ),
        ),
      ),
      themeColor: Theme.of(context).primaryColor,
      title: Text("Nouvelle note"),
      actionButtons: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Annuler"),
        ),
        TextButton(
          onPressed: () => _addGrade(),
          child: Text("Enregistrer"),
        ),
      ],
    );
  }
}
