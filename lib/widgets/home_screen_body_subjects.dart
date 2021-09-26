import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/empty_centered_text.dart';

import 'subject_card.dart';
import '../models/my_database.dart';

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
                    "Aucune matières pour le moment.\nPour créer une matière, clique sur le +");
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
