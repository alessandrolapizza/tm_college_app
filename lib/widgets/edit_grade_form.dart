import "package:flutter/material.dart";
import 'package:tm_college_app/models/matiere.dart';

class EditGradeForm extends StatelessWidget {
  final Function onChangedFunction;

  final String dropdownValue;

  final List<Matiere> subjects;

  final GlobalKey<FormState> editGradeFormKey;

  EditGradeForm({
    @required this.dropdownValue,
    @required this.onChangedFunction,
    @required this.subjects,
    @required this.editGradeFormKey,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: editGradeFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField(
            value: dropdownValue,
            onChanged: (value) => onChangedFunction(value),
            items: List.from([
              DropdownMenuItem(
                  child: Text("Sélectionner une matière"), value: "0")
            ])
              ..addAll(subjects.map<DropdownMenuItem<String>>(
                (Matiere value) {
                  return DropdownMenuItem<String>(
                    value: value.id,
                    child: Text(value.nom),
                  );
                },
              ).toList()),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 15),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  selectionControls: materialTextSelectionControls,
                  validator: (value) {
                    if (value == null) {
                      return "Une note doit être fournie";
                    } else if (int.parse(value) >= 1 && int.parse(value) <= 6) {
                      return null;
                    } else {
                      return "La note doit être comprise entre 1 et 6";
                    }
                  }, //changer
                  controller: null, // changer
                  maxLength: 3,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    labelText: "Note",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15),
              ),
              Expanded(
                child: TextFormField(
                  selectionControls: materialTextSelectionControls,
                  controller: null, // changer
                  maxLength: 3,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    labelText: "Coefficient",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
