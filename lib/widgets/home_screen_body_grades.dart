import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/models/grade.dart';
import 'package:tm_college_app/widgets/grade_card.dart';

class HomeScreenBodyGrades extends StatelessWidget {
  final BaseDeDonnees database;

  final SharedPreferences sharedPreferences;

  final Function onTapFunctionGradeCard;

  HomeScreenBodyGrades({
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
          child = ListView.builder(
            itemCount: gradesSorted.length,
            itemBuilder: (_, index) {
              return GradeCard(
                onTapFunction: () => onTapFunctionGradeCard(
                    index: index, subject: averages.keys.toList()[index]),
                subject: averages.keys.toList()[index],
                averages: averages[averages.keys.toList()[index]],
              );
            },
          );
        } else {
          child = Center(child: CircularProgressIndicator());
        }
        return child;
      },
    );
  }
}
