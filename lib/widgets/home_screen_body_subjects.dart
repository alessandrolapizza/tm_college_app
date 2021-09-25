import "package:flutter/material.dart";

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
        var children;
        if (snapshot.hasData) {
          children = ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              return CarteMatiere(
                matiere: snapshot.data[index],
                onTapFunction: () => onTapSubjectCardFunction(subject: snapshot.data[index]),
              );
            },
          );
        } else {
          children = Center(child: CircularProgressIndicator());
        }
        return children;
      },
    );
  }
}
