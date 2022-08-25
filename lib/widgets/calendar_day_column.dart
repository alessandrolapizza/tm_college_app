import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/homework.dart';
import 'package:tm_college_app/models/my_database.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/fade_gradient.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';
import 'package:tm_college_app/widgets/view_homework_content.dart';
import 'package:tm_college_app/widgets/view_homework_details_sentence.dart';
import 'package:tm_college_app/widgets/view_homework_priority_banner.dart';

class CalendarDayColumn extends StatelessWidget {
  final DateTime day;

  final bool today;

  final bool selected;

  final List<Homework> homeworks;

  final Function checkFunction;

  final Notifications notifications;

  final MyDatabase database;

  final Function deleteFunction;

  final Function selectDayFunction;

  final SharedPreferences sharedPreferences;

  CalendarDayColumn({
    @required this.checkFunction,
    @required this.day,
    @required this.homeworks,
    @required this.notifications,
    @required this.database,
    @required this.deleteFunction,
    @required this.selectDayFunction,
    @required this.sharedPreferences,
    this.today = false,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Center(
            child: selected
                ? CircleAvatar(
                    radius: 15,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  )
                : today
                    ? CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.red,
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          radius: 14,
                          child: Text(day.day.toString(),
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.red,
                              )),
                        ),
                      )
                    : Text(
                        day.day.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          color:
                              day.isAfter(DateTime.now()) ? null : Colors.red,
                        ),
                      ),
          ),
        ),
        Expanded(
          flex: 5,
          child: FadeGradient(
            child: ListView.builder(
              itemCount: homeworks.length,
              itemBuilder: (_, index) {
                if (homeworks[index].dueDate.year == day.year &&
                    homeworks[index].dueDate.month == day.month &&
                    homeworks[index].dueDate.day == day.day &&
                    !homeworks[index].done) {
                  return InkWell(
                    onTap: () {
                      selectDayFunction(day);
                      showDialog(
                        context: context,
                        builder: (_) {
                          return ModularAlertDialog(
                            actionButtons: [
                              TextButton(
                                onPressed: () =>
                                    deleteFunction(homeworks[index]),
                                child: Icon(Icons.delete_rounded),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  // SystemChrome.setPreferredOrientations([
                                  //   DeviceOrientation.portraitUp,
                                  // ]);
                                  Navigator.pushNamed(
                                    context,
                                    "/edit_homework_screen",
                                    arguments: [
                                      homeworks[index],
                                      false,
                                    ],
                                  );
                                },
                                child: Icon(Icons.edit_rounded),
                              ),
                              TextButton(
                                onPressed: () async => await checkFunction(
                                  homeworks[index],
                                ),
                                child: Icon(Icons.check_rounded),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("Fermer"),
                              )
                            ],
                            content: FadeGradient(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 17,
                                      child: ViewHomeworkPriorityBanner(
                                        homework: homeworks[index],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                    ),
                                    ViewHomeworkContent(
                                      homework: homeworks[index],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            themeColor: homeworks[index].subject.color,
                            title: ViewHomeworkDetailsSentence(
                              homePage: true,
                              homework: homeworks[index],
                            ),
                          );
                        },
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(3), // Enlever ptt..
                      color: homeworks[index].subject.color,
                      child: Container(
                        height: 35,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Card(
                                elevation: 3,
                                child: Container(
                                  height: 20,
                                ),
                                color: Homework.priorityColorMap.values
                                    .toList()[homeworks[index].priority],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                homeworks[index].subject.name,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: ThemeData.estimateBrightnessForColor(
                                              homeworks[index].subject.color) ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              flex: 5,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (homeworks.length == index) {
                  return Container();
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
