import "package:flutter_iconpicker/flutter_iconpicker.dart";
import "package:flutter_material_color_picker/flutter_material_color_picker.dart";
import "package:flutter/material.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "../models/subject.dart";
import "./app.dart";
import "./edit_subject_body.dart";
import "./modular_alert_dialog.dart";
import "./modular_app_bar.dart";
import "./modular_icon_button.dart";
import "./theme_controller.dart";

class EditSubjectScreen extends StatefulWidget {
  final MyDatabase database;

  final Notifications notifications;

  EditSubjectScreen({
    @required this.database,
    @required this.notifications,
  });

  @override
  _EditSubjectScreenState createState() => _EditSubjectScreenState();
}

class _EditSubjectScreenState extends State<EditSubjectScreen> {
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
    int validColor = 0;

    Color color = await showDialog(
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
              if (validColor == 0) {
                validColor++;
              } else {
                Navigator.pop(context, couleur);
              }
            },
            onBack: () => validColor--,
            physics: ScrollPhysics(
              parent: NeverScrollableScrollPhysics(),
            ),
          ),
        );
      },
    );
    if (color != null) {
      setState(() => _selectedColor = color);
    }
  }

  Future<void> _createSubject() async {
    if (_createSubjectFormKey.currentState.validate() &&
        _selectedIcon != null &&
        _selectedColor != null) {
      if (_subjectId != null) {
        widget.database.updateSubject(
          Subject(
            color: _selectedColor,
            icon: _selectedIcon,
            name: _subjectNameController.text,
            room: _subjectRoomNumberController.text,
            id: _subjectId,
          ),
        );
      } else {
        await widget.database.inserertSubject(
          Subject(
            color: _selectedColor,
            icon: _selectedIcon,
            name: _subjectNameController.text,
            room: _subjectRoomNumberController.text,
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
      final Subject subject = arguments[0];
      _subjectNameController.text = subject.name;
      _subjectRoomNumberController.text = subject.room;
      _selectedColor = subject.color;
      _selectedIcon = subject.icon;
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
                    icon: Icons.delete_rounded,
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
                                  await widget.database.deleteSubject(
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
