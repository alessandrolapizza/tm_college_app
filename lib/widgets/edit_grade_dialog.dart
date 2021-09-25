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

  final Grade grade;

  final bool singleSubject;

  EditGradeDialog({
    @required this.sharedPreferences,
    @required this.database,
    this.singleSubject = false,
    this.grade,
    this.subjects,
  });

  @override
  _EditGradeDialogState createState() => _EditGradeDialogState();
}

class _EditGradeDialogState extends State<EditGradeDialog> {
  final GlobalKey<FormState> _editGradeFormKey = GlobalKey();

  final TextEditingController _coefficientController =
      TextEditingController(text: "1");

  final TextEditingController _gradeController = TextEditingController();

  DateTime _selectedGradeDate = DateTime.now();

  String _dropdownValue = "0";

  bool _gradeDateMissing = false;

  void initState() {
    super.initState();
    if (widget.grade != null) {
      _gradeController.text = widget.grade.grade.toString();
      _selectedGradeDate = widget.grade.date;
      _coefficientController.text =
          widget.grade.coefficient.toString().substring(0, 3);
    }
  }

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

  _editGrade() {
    if (_editGradeFormKey.currentState.validate() &&
        _selectedGradeDate != null) {
      if (widget.grade != null) {
        widget.database.updateGrade(Grade(
            coefficient:
                double.parse(_coefficientController.text.replaceAll(",", ".")),
            date: _selectedGradeDate,
            grade: double.parse(_gradeController.text.replaceAll(",", ".")),
            subjectId: widget.grade.subjectId,
            id: widget.grade.id));
      } else {
        widget.database.insertGrade(
          Grade(
              coefficient: double.parse(
                  _coefficientController.text.replaceAll(",", ".")),
              date: _selectedGradeDate,
              grade: double.parse(_gradeController.text.replaceAll(",", ".")),
              subjectId: widget.subjects.length == 1
                  ? widget.subjects[0].id
                  : _dropdownValue),
        );
      }
      Navigator.pop(context);
    } else if (_selectedGradeDate == null) {
      setState(() => _gradeDateMissing = true);
    } else {
      setState(() => _gradeDateMissing = false);
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
                  singleSubject: widget.singleSubject,
                  gradeController: _gradeController,
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
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                ),
              ],
            ),
          ),
        ),
      ),
      themeColor: Theme.of(context).primaryColor,
      title: Text(widget.subjects == null ? "Modifier note" : "Nouvelle note"),
      actionButtons: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Annuler"),
        ),
        TextButton(
          onPressed: () => _editGrade(),
          child: Text("Enregistrer"),
        ),
      ],
    );
  }
}
