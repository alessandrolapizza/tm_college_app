import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/circle_avatar_with_border.dart';
import 'package:tm_college_app/widgets/modular_chart.dart';

class HomeScreenBodyGrades extends StatelessWidget {
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
                            CircleAvatarWithBorder(color: Colors.red, icon: Icons.date_range),
                            Text(
                              "Mathématiques",
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    flex: 4,
                    child: ModularChart(data: {
                      "Janvier": 4,
                      "Février": 3,
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "4.5",
                  style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green, fontSize: 30),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
