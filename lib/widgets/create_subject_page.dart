import "package:flutter/material.dart";

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import "package:flutter_iconpicker/flutter_iconpicker.dart";
import 'package:tm_college_app/widgets/create_subject_body.dart';

import "./modular_app_bar.dart";
import "../models/base_de_donnees.dart";
import "../models/matiere.dart";

class CreateSubjectPage extends StatefulWidget {
  final BaseDeDonnees bD;

  CreateSubjectPage(this.bD);

  @override
  _CreateSubjectPageState createState() => _CreateSubjectPageState(bD);
}

class _CreateSubjectPageState extends State<CreateSubjectPage> {
  final BaseDeDonnees _bD;

  _CreateSubjectPageState(this._bD);

  final TextEditingController _subjectNameController = TextEditingController();

  final TextEditingController _subjectRoomNumberController =
      TextEditingController();

  IconData _selectedIcon;

  Color _selectedColor;

  void _selectIcon(context) async {
    IconData _icon = await FlutterIconPicker.showIconPicker(
      context,
      noResultsText: "Aucun résultats pour :",
      searchHintText: "Rechercher (anglais)",
      closeChild: Text("Annuler"),
      barrierDismissible: true,
      title: Text("Choisir un icon"),
    );

    if (_icon != null) {
      setState(() => _selectedIcon = _icon);
    }
  }

  void _selectColor() async {
    int _couleurValide = 0;

    Color _couleur = await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Choisir une couleur"),
          actions: [
            TextButton(
              child: Text("Annuler"),
              onPressed: () => Navigator.pop(context),
            )
          ],
          content: MaterialColorPicker(
            shrinkWrap: true,
            onColorChange: (Color couleur) {
              if (_couleurValide == 0) {
                _couleurValide++;
              } else {
                Navigator.pop(context, couleur);
              }
            },
            onBack: () => _couleurValide--,
            physics: ScrollPhysics(
              parent: NeverScrollableScrollPhysics(),
            ),
          ),
        );
      },
    );
    if (_couleur != null) {
      setState(() => _selectedColor = _couleur);
    }
  }

  Future<void> _createSubject() async {
    await _bD.insererMatiere(
      Matiere(
        couleurMatiere: _selectedColor,
        iconMatiere: _selectedIcon,
        nom: _subjectNameController.text,
        salle: _subjectRoomNumberController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        title: "Nouvelle matière",
        centerTitle: true,
      ),
      body: CreateSubjectBody(
        selectIconFunction: _selectIcon,
        selectedIcon: _selectedIcon,
        selectColor: _selectColor,
        selectedColor: _selectedColor,
        createSubjectFunction: _createSubject,
        subjectNameController: _subjectNameController,
        subjectRoomNumberController: _subjectRoomNumberController,
      ),
    );
  }
}
