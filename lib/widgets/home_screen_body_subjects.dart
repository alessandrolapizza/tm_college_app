import "package:flutter/material.dart";

import "./carte_matiere.dart";
import "../models/base_de_donnees.dart";

class HomeScreenBodySubjects extends StatelessWidget {
  final BaseDeDonnees db;

  HomeScreenBodySubjects(this.db);

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
              debugPrint(snapshot.data[index].id);
              return CarteMatiere(
                matiere: snapshot.data[index],
                onTapFunction: () => Navigator.pushNamed(
                  context,
                  "/page_visualiser_matiere",
                  arguments: snapshot.data[index],
                ),
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
