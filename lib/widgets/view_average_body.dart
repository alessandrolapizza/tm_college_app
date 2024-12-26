import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/grade.dart";
import "../models/my_database.dart";
import "../models/subject.dart";
import "./average_card.dart";
import "./edit_grade_dialog.dart";
import "./grades_list.dart";
import "./modular_alert_dialog.dart";

class ViewAverageBody extends StatefulWidget {
  final MyDatabase database;

  final SharedPreferences sharedPreferences;

  final Subject subject;

  final int index;

  ViewAverageBody({
    required this.database,
    required this.sharedPreferences,
    required this.subject,
    required this.index,
  });

  @override
  _ViewAverageBodyState createState() => _ViewAverageBodyState();
}

class _ViewAverageBodyState extends State<ViewAverageBody> {
  final ScrollController _gradesScrollController = ScrollController();

  _deleteGrade({
    required String gradeId,
    bool lastGrade = false,
  }) {
    showDialog(
      context: context,
      builder: (_) {
        return ModularAlertDialog(
          themeColor: widget.subject.color,
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
                  double offset = _gradesScrollController.offset;
                  _gradesScrollController.animateTo(
                    offset + 0.5,
                    duration: Duration(milliseconds: 1),
                    curve: Curves.bounceIn,
                  );
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

  _editGrade({required Grade grade}) {
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
        // List<dynamic> maps;
        Map<Subject?, List<Map<DateTime, double>>> averages = {};
        Map<Subject?, Map<DateTime, List<Grade>>> gradesSorted = {};
        if (snapshot.hasData) {
          final maps = Grade.gradesMaps(
            grades: snapshot.data!, // as List<Grade>,
            sharedPreferences: widget.sharedPreferences,
          );
          gradesSorted = maps[0];
          averages = maps[1];
        }
        Widget child = Column(
          children: [
            Hero(
              tag: "${widget.subject.id}",
              child: Material(
                child: AverageCard(
                  subject: widget.subject,
                  averages: snapshot.hasData
                      ? averages[averages.keys.toList()[widget.index]]
                      : null,
                ),
              ),
            ),
            if (snapshot.hasData)
              Expanded(
                child: GradesList(
                  gradesScrollController: _gradesScrollController,
                  editGradeFunction: _editGrade,
                  deleteGradeFunction: _deleteGrade,
                  sharedPreferences: widget.sharedPreferences,
                  gradesSortedSubjectSpecific:
                      gradesSorted[averages.keys.toList()[widget.index]],
                ),
              ),
          ],
        );
        return child;
      },
    );
  }
}
