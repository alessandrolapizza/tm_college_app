import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/models/grade.dart';
import 'package:tm_college_app/models/matiere.dart';
import 'package:tm_college_app/widgets/edit_grade_dialog.dart';
import 'package:tm_college_app/widgets/grade_card.dart';
import 'package:tm_college_app/widgets/grades_list.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';

class ViewGradeBody extends StatefulWidget {
  final BaseDeDonnees database;

  final SharedPreferences sharedPreferences;

  final Matiere subject;

  final int index;

  ViewGradeBody({
    @required this.database,
    @required this.sharedPreferences,
    @required this.subject,
    @required this.index,
  });

  @override
  _ViewGradeBodyState createState() => _ViewGradeBodyState();
}

class _ViewGradeBodyState extends State<ViewGradeBody> {
  deleteGrade({
    @required String gradeId,
    bool lastGrade = false,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return ModularAlertDialog(
          themeColor: widget.subject.couleurMatiere,
          title: Text("Supprimer note ?"),
          content: Text("Es-tu sûr de vouloir supprimer cette note ?"),
          actionButtons: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                widget.database.deleteGrade(gradeId);
                Navigator.pop(context);
                if (lastGrade) {
                  Navigator.pop(context);
                } else {
                  setState(() {});
                }
              },
              child: Text(
                "Supprimer",
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        );
      },
    );
  }

  editGrade({@required Grade grade}) {
    showDialog(
      context: context,
      builder: (_) {
        return EditGradeDialog(
          sharedPreferences: widget.sharedPreferences,
          database: widget.database,
          grade: grade,
        );
      },
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.database.grades(),
      builder: (_, snapshot) {
        Widget child;
        if (snapshot.hasData) {
          final maps = Grade.gradesMaps(
            grades: snapshot.data,
            sharedPreferences: widget.sharedPreferences,
          );
          final Map<Matiere, Map<DateTime, List<Grade>>> gradesSorted = maps[0];
          final Map<Matiere, List<Map<DateTime, double>>> averages = maps[1];
          child = Column(
            children: [
              GradeCard(
                subject: widget.subject,
                averages: averages[averages.keys.toList()[widget.index]],
              ),
              Expanded(
                child: GradesList(
                  editGradeFunction: editGrade,
                  deleteGradeFunction: deleteGrade,
                  sharedPreferences: widget.sharedPreferences,
                  gradesSortedSubjectSpecific:
                      gradesSorted[averages.keys.toList()[widget.index]],
                ),
              ),
            ],
          );
        } else {
          child = Center(child: CircularProgressIndicator());
        }
        return child;
      },
    );
  }
}
