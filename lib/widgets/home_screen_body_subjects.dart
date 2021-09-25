import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/empty_centered_text.dart';

import "./carte_matiere.dart";
import "../models/base_de_donnees.dart";

class HomeScreenBodySubjects extends StatelessWidget {
  final BaseDeDonnees db;

  final Function onTapSubjectCardFunction;

  HomeScreenBodySubjects({
    @required this.db,
    @required this.onTapSubjectCardFunction,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: db.matieres(),
      builder: (_, snapshot) {
        var child;
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            child = EmptyCenteredText(
                content:
                    "Aucune matières pour le moment.\nPour créer une matière, clique sur le +");
          } else {
            child = ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return CarteMatiere(
                  matiere: snapshot.data[index],
                  onTapFunction: () =>
                      onTapSubjectCardFunction(subject: snapshot.data[index]),
                );
              },
            );
          }
        } else {
          child = Center(child: CircularProgressIndicator());
        }
        return child;
      },
    );
  }
}
