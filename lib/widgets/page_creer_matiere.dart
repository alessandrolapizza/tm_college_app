import "package:flutter/material.dart";

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import "package:flutter_iconpicker/flutter_iconpicker.dart";

import "../models/base_de_donnees.dart";
import "../models/matiere.dart";

class PageCreerMatiere extends StatefulWidget {
  final BaseDeDonnees bD;

  PageCreerMatiere(this.bD);
  @override
  _PageCreerMatiereState createState() => _PageCreerMatiereState(bD);
}

class _PageCreerMatiereState extends State<PageCreerMatiere> {
  TextEditingController _nomMatiereController = TextEditingController();
  TextEditingController _salleController = TextEditingController();

  IconData _iconSelectionne;
  Color _couleurSelectionne;

  BaseDeDonnees _bD;

  _PageCreerMatiereState(this._bD);

  void _selectionnerIcon(context) async {
    IconData _icon = await FlutterIconPicker.showIconPicker(
      context,
      noResultsText: "Aucun résultats pour :",
      searchHintText: "Rechercher (anglais)",
      closeChild: Text("Annuler"),
      barrierDismissible: true,
      title: Text("Choisir un icon"),
    );

    if (_icon != null) {
      setState(() => _iconSelectionne = _icon);
    }
  }

  void _selectionnerCouleur() async {
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
      setState(() => _couleurSelectionne = _couleur);
    }
  }

  Future<void> _nouvelleMatiere() async {
    await _bD.insererMatiere(
      Matiere(
        couleurMatiere: _couleurSelectionne,
        iconMatiere: _iconSelectionne,
        nom: _nomMatiereController.text,
        salle: _salleController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouvelle matière"),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.05,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                ),
                Column(
                  children: [
                    TextField(
                      controller: _nomMatiereController,
                      autofocus: true,
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      onEditingComplete: () =>
                          FocusScope.of(context).nextFocus(),
                      decoration: InputDecoration(
                        icon: Icon(Icons.text_fields_rounded),
                        labelText: "Nom de la matière",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    ),
                    TextField(
                      controller: _salleController,
                      maxLength: 5,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        icon: Icon(Icons.format_list_numbered_rtl_rounded),
                        labelText: "Numéro de salle",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: OutlinedButton(
                            onPressed: () => _selectionnerIcon(context),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Icon "),
                                Icon(
                                  _iconSelectionne == null
                                      ? Icons.edit
                                      : _iconSelectionne,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.3,
                          child: OutlinedButton(
                            onPressed: () => _selectionnerCouleur(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Couleur "),
                                _couleurSelectionne == null
                                    ? Icon(
                                        Icons.edit,
                                        size: 20,
                                      )
                                    : CircleColor(
                                        color: _couleurSelectionne,
                                        circleSize: 20,
                                      ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Annuler"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _nouvelleMatiere();
                            Navigator.pop(context);
                          },
                          child: Text("Enregistrer"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
