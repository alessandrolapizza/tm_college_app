import "package:flutter/material.dart";
import 'package:tm_college_app/models/grade.dart';
import 'package:tm_college_app/models/matiere.dart';
import 'package:tm_college_app/widgets/circle_avatar_with_border.dart';
import 'package:tm_college_app/widgets/modular_chart.dart';

class GradeCard extends StatelessWidget {
  final Matiere subject;

  final List<Map<DateTime, double>> averages;

  GradeCard({
    @required this.subject,
    this.averages,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
          child: Container(
        height: 100,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            CircleAvatarWithBorder(
                                color: subject.couleurMatiere,
                                icon: subject.iconMatiere),
                            Text(
                              subject.nom,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 4,
                    child: ModularChart(
                      averages: averages,
                      color: Grade.color(
                        average: double.parse(
                          averages[averages.length - 1]
                              .values
                              .toList()[0]
                              .toStringAsFixed(1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  averages[averages.length - 1]
                      .values
                      .toList()[0]
                      .toStringAsFixed(1),
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Grade.color(
                        average: double.parse(
                          averages[averages.length - 1]
                              .values
                              .toList()[0]
                              .toStringAsFixed(1),
                        ),
                      ),
                      fontSize: 30),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
