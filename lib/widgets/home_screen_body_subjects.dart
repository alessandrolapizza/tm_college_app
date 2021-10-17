import "package:flutter/material.dart";
import "../models/my_database.dart";
import "./empty_centered_text.dart";
import "./subject_card.dart";

class HomeScreenBodySubjects extends StatelessWidget {
  final MyDatabase database;

  final Function onTapSubjectCardFunction;

  HomeScreenBodySubjects({
    @required this.database,
    @required this.onTapSubjectCardFunction,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: database.subjects(),
      builder: (_, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            child = EmptyCenteredText(
                content:
                    "Aucune matière pour le moment.\nPour créer une matière, clique sur le +");
          } else {
            child = ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (_, index) {
                return SubjectCard(
                  subject: snapshot.data[index],
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
