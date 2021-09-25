import "package:flutter/material.dart";

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import "package:flutter_iconpicker/flutter_iconpicker.dart";
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/app.dart';
import 'package:tm_college_app/widgets/edit_subject_body.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';
import 'package:tm_college_app/widgets/modular_icon_button.dart';
import 'package:tm_college_app/widgets/theme_controller.dart';

import "./modular_app_bar.dart";
import "../models/base_de_donnees.dart";
import "../models/matiere.dart";

class EditSubjectScreen extends StatefulWidget {
  final BaseDeDonnees bD;

  final Notifications notifications;

  EditSubjectScreen({
    @required this.bD,
    @required this.notifications,
  });

  @override
  _EditSubjectScreenState createState() => _EditSubjectScreenState(bD);
}

class _EditSubjectScreenState extends State<EditSubjectScreen> {
  final BaseDeDonnees _bD;

  _EditSubjectScreenState(this._bD);

  final TextEditingController _subjectNameController = TextEditingController();

  final TextEditingController _subjectRoomNumberController =
      TextEditingController();

  final GlobalKey<FormState> _createSubjectFormKey = GlobalKey();

  IconData _selectedIcon;

  Color _selectedColor;

  bool _iconMissing = false;

  bool _colorMissing = false;

  String _subjectId;

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
          actionButtons: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            )
          ],
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
      if (_subjectId != null) {
        _bD.modifierMatiere(
          Matiere(
            couleurMatiere: _selectedColor,
            iconMatiere: _selectedIcon,
            nom: _subjectNameController.text,
            salle: _subjectRoomNumberController.text,
            id: _subjectId,
          ),
        );
      } else {
        await _bD.insererMatiere(
          Matiere(
            couleurMatiere: _selectedColor,
            iconMatiere: _selectedIcon,
            nom: _subjectNameController.text,
            salle: _subjectRoomNumberController.text,
          ),
        );
      }
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
    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;
    if (_subjectId == null && arguments != null) {
      final Matiere subject = arguments[0];
      _subjectNameController.text = subject.nom;
      _subjectRoomNumberController.text = subject.salle;
      _selectedColor = subject.couleurMatiere;
      _selectedIcon = subject.iconMatiere;
      setState(() => _subjectId = subject.id);
    }

    return ThemeController(
      color: _selectedColor == null
          ? Color(App.defaultColorThemeValue)
          : _selectedColor,
      child: Scaffold(
        appBar: ModularAppBar(
          hideSettingsButton: true,
          backArrow: true,
          title: Text("Nouvelle matière"),
          centerTitle: true,
          actions: _subjectId != null
              ? [
                  ModularIconButton(
                    icon: Icons.delete,
                    onPressedFunction: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return ModularAlertDialog(
                            title: Text("Supprimer matière ?"),
                            content: Text(
                                "Es-tu sûr de vouloir supprimer cette matière ?"),
                            themeColor: _selectedColor,
                            actionButtons: [
                              TextButton(
                                child: Text("Annuler"),
                                onPressed: () => Navigator.pop(context),
                              ),
                              TextButton(
                                child: Text(
                                  "Supprimer",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () async {
                                  await widget.bD.deleteSubject(
                                    subject: arguments[0],
                                    notifications: widget.notifications,
                                  );
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ]
              : null,
        ),
        body: EditSubjectBody(
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
