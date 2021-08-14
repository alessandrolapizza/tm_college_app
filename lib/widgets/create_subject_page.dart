import "package:flutter/material.dart";

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import "package:flutter_iconpicker/flutter_iconpicker.dart";
import 'package:tm_college_app/widgets/app.dart';
import 'package:tm_college_app/widgets/create_subject_body.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';
import 'package:tm_college_app/widgets/theme_controller.dart';

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

  final GlobalKey<FormState> _createSubjectFormKey = GlobalKey();

  IconData _selectedIcon;

  Color _selectedColor;

  bool _iconMissing = false;

  bool _colorMissing = false;

  void _selectIcon(BuildContext ctx) async {
    IconData _icon = await FlutterIconPicker.showIconPicker(
      context,
      noResultsText: "Aucun résultats pour :",
      searchHintText: "Rechercher (anglais)",
      closeChild: Text(
        "Annuler",
        style: TextStyle(
          color:
              Theme.of(ctx).outlinedButtonTheme.style.foregroundColor.resolve(
                    Set<MaterialState>.from(MaterialState.values),
                  ),
        ),
      ),
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
        return ModularAlertDialog(
          themeColor: _selectedColor == null
              ? Color(App.defaultColorThemeValue)
              : _selectedColor,
          title: Text(
            "Choisir une couleur",
            style: TextStyle(color: Colors.black),
          ),
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
    if (_createSubjectFormKey.currentState.validate() &&
        _selectedIcon != null &&
        _selectedColor != null) {
      await _bD.insererMatiere(
        Matiere(
          couleurMatiere: _selectedColor,
          iconMatiere: _selectedIcon,
          nom: _subjectNameController.text,
          salle: _subjectRoomNumberController.text,
        ),
      );
      Navigator.pop(context);
    } else {
      if (_selectedColor == null) {
        _colorMissing = true;
      } else {
        _colorMissing = false;
      }
      setState(() => _colorMissing);
      if (_selectedIcon == null) {
        _iconMissing = true;
      } else {
        _iconMissing = false;
      }
      setState(() => _iconMissing);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeController(
      color: _selectedColor == null
          ? Color(App.defaultColorThemeValue)
          : _selectedColor,
      child: Scaffold(
        appBar: ModularAppBar(
          backArrow: true,
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
          createSubjectFormKey: _createSubjectFormKey,
          iconMissing: _iconMissing,
          colorMissing: _colorMissing,
        ),
      ),
    );
  }
}
