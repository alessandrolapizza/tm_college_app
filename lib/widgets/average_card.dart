import "package:flutter/material.dart";
import "../models/grade.dart";
import "../models/subject.dart";
import "./circle_avatar_with_border.dart";
import "./modular_chart.dart";

class AverageCard extends StatelessWidget {
  final Subject? subject;

  final List<Map<DateTime, double>>? averages;

  final Function? onTapFunction;

  AverageCard({
    required this.subject,
    required this.averages,
    this.onTapFunction,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapFunction != null ? onTapFunction as void Function()? : null,
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
                                color: subject!.color, icon: subject!.icon),
                            Text(
                              subject!.name!,
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
                    child: averages == null
                        ? Text("Chargement")
                        : ModularChart(
                            averages: averages,
                            color: averages == null
                                ? Colors.red
                                : Grade.color(
                                    average: double.parse(
                                      averages![averages!.length - 1]
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
                child: averages == null
                    ? Text("Chargement ...")
                    : Text(
                        averages![averages!.length - 1]
                            .values
                            .toList()[0]
                            .toStringAsFixed(1),
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Grade.color(
                              average: double.parse(
                                averages![averages!.length - 1]
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
