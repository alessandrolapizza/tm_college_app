import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/my_database.dart";
import "../models/grade.dart";
import "./empty_centered_text.dart";
import "./average_card.dart";

class HomeScreenBodyAverages extends StatelessWidget {
  final MyDatabase database;

  final SharedPreferences sharedPreferences;

  final Function onTapFunctionGradeCard;

  HomeScreenBodyAverages({
    @required this.database,
    @required this.sharedPreferences,
    @required this.onTapFunctionGradeCard,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: database.grades(),
      builder: (_, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          final List maps = Grade.gradesMaps(
            grades: snapshot.data,
            sharedPreferences: sharedPreferences,
          );
          final gradesSorted = maps[0];
          final averages = maps[1];
          if (gradesSorted.length == 0) {
            child = EmptyCenteredText(
                content:
                    "Aucune moyenne pour le moment.\nPour ajouter une note, clique sur le +");
          } else {
            child = ListView.builder(
              itemCount: gradesSorted.length,
              itemBuilder: (_, index) {
                return AverageCard(
                  onTapFunction: () => onTapFunctionGradeCard(
                      index: index, subject: averages.keys.toList()[index]),
                  subject: averages.keys.toList()[index],
                  averages: averages[averages.keys.toList()[index]],
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
