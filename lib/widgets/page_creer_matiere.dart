import "package:flutter/material.dart";

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import "package:flutter_iconpicker/flutter_iconpicker.dart";

import "../models/base_de_donnees.dart";
import "../models/matiere.dart";

import 'dart:math'; //provisoire

Random random = Random(); //provisoire
int randomNumber = random.nextInt(10000); //provisoire

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
    _iconSelectionne = await FlutterIconPicker.showIconPicker(
      context,
      noResultsText: "Aucun résultats pour :",
      searchHintText: "Rechercher (anglais)",
      closeChild: Text("Annuler"),
      barrierDismissible: false,
      title: Text("Choisir un icon"),
    );

    setState(() => _iconSelectionne);
  }

  void _selectionnerCouleur() async {
    int _couleurValide = 0;

    _couleurSelectionne = await showDialog(
      barrierDismissible: false,
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
          content: SizedBox(
            height: MediaQuery.of(context).size.height / 4,
            child: MaterialColorPicker(
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
          ),
        );
      },
    );

    setState(() => _couleurSelectionne);
  }

  Future<void> _nouvelleMatiere() async {
    await _bD.insererMatiere(
      Matiere(
        couleurMatiere: _couleurSelectionne,
        id: randomNumber,
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
                Wrap(
                  runSpacing: 15,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
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
                          width: MediaQuery.of(context).size.width / 2.5,
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
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Annuler"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                        ),
                        OutlinedButton(
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
