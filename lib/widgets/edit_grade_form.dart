import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:tm_college_app/models/matiere.dart';

class EditGradeForm extends StatelessWidget {
  final Function onChangedFunction;

  final String dropdownValue;

  final List<Matiere> subjects;

  final GlobalKey<FormState> editGradeFormKey;

  final TextEditingController coefficientController;

  EditGradeForm({
    @required this.dropdownValue,
    @required this.onChangedFunction,
    @required this.subjects,
    @required this.editGradeFormKey,
    @required this.coefficientController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: editGradeFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField(
            validator: (value) {
              if (value == "0") {
                return "Une matière doit être sélectionnée";
              } else {
                return null;
              }
            },
            value: dropdownValue,
            onChanged: (value) => onChangedFunction(value),
            items: List.from(
              [
                DropdownMenuItem(
                    child: Text("Sélectionner une matière"), value: "0")
              ],
            )..addAll(
                subjects.map<DropdownMenuItem<String>>(
                  (Matiere value) {
                    return DropdownMenuItem<String>(
                      value: value.id,
                      child: Text(value.nom),
                    );
                  },
                ).toList(),
              ),
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
                    bool isDouble = false;
                    try {
                      double.parse(value);
                      isDouble = true;
                    } on FormatException {
                      isDouble = false;
                    }
                    if (value == null || value == "") {
                      return "Une note doit être fournie";
                    } else if (!isDouble) {
                      return "Une note valide doit être fournie";
                    } else if (double.parse(value) >= 1 &&
                        double.parse(value) <= 6) {
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
                  validator: (value) {
                    bool isDouble = false;
                    try {
                      double.parse(value);
                      isDouble = true;
                    } on FormatException {
                      isDouble = false;
                    }
                    if (value == null || value == "") {
                      return "Un coefficient doit être fourni";
                    } else if (!isDouble) {
                      return "Un coefficient valide doit être fourni";
                    } else {
                      return null;
                    }
                  },
                  selectionControls: materialTextSelectionControls,
                  controller: coefficientController, // changer
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
