import "package:flutter/material.dart";

import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import "package:flutter_iconpicker/flutter_iconpicker.dart";

class PageCreerMatiere extends StatefulWidget {
  @override
  _PageCreerMatiereState createState() => _PageCreerMatiereState();
}

class _PageCreerMatiereState extends State<PageCreerMatiere> {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextField(
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
                            maxLength: 5,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              icon:
                                  Icon(Icons.format_list_numbered_rtl_rounded),
                              labelText: "Numéro de salle",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            var iconSelected =
                                await FlutterIconPicker.showIconPicker(
                              context,
                              noResultsText: "Aucun résultats pour :",
                              searchHintText: "Rechercher (anglais)",
                              closeChild: Text("Annuler"),
                              barrierDismissible: false,
                              title: Text("Choisir un icon"),
                            );
                            print(iconSelected);
                          },
                          child: Row(
                            children: [
                              Text("Icon "),
                              Icon(Icons.edit),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            showDialog(
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
                                      height:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: MaterialColorPicker(
                                        physics: ScrollPhysics(
                                          parent:
                                              NeverScrollableScrollPhysics(),
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Row(
                            children: [
                              Text("Couleur "),
                              Icon(Icons.edit),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Align(
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
                        onPressed: () {},
                        child: Text("Enregistrer"),
                      ),
                    ],
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
