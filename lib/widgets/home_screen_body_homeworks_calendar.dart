import "package:flutter/material.dart";
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tm_college_app/models/homework.dart';
import 'package:tm_college_app/models/my_database.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/calendar_day_column.dart';
import 'package:tm_college_app/widgets/modular_alert_dialog.dart';

class HomeScreenBodyHomeworksCalendar extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  final MyDatabase database;

  final Notifications notifications;

  HomeScreenBodyHomeworksCalendar({
    @required this.notifications,
    @required this.sharedPreferences,
    @required this.database,
  });

  @override
  State<HomeScreenBodyHomeworksCalendar> createState() =>
      _HomeScreenBodyHomeworksCalendarState();
}

class _HomeScreenBodyHomeworksCalendarState
    extends State<HomeScreenBodyHomeworksCalendar> {
  DateTime selectedDayVar;

  DateTime focusedDayVar;

  void checkHomework(Homework homework) async {
    await Homework.homeworkChecker(
      homework: homework,
      database: widget.database,
      notifications: widget.notifications,
    );
    Navigator.pop(context);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Devoir marqué comme \"complété\"."),
      ),
    );
  }

  void deleteHomework(Homework homework) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return ModularAlertDialog(
          themeColor: homework.subject.color,
          title: Text("Supprimer devoir ?"),
          content: Text("Es-tu sûr de vouloir supprimer ce devoir ?"),
          actionButtons: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            ),
            TextButton(
              child: Text(
                "Supprimer",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await widget.database.deleteHomework(
                  homework: homework,
                  notifications: widget.notifications,
                );
                Navigator.pop(context);
                Navigator.pop(context);
                setState(() {});
              },
            )
          ],
        );
      },
    );
  }

  void selectDay(DateTime day) async {
    await widget.sharedPreferences
        .setString("selectedDayCalendar", day.toString());
    setState(() {
      selectedDayVar = day;
      focusedDayVar = day;
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.sharedPreferences.getString("selectedCalendarDay") != null) {
  //     selectedDayVar = DateTime.parse(
  //         widget.sharedPreferences.getString("selectedCalendarDay"));
  //     focusedDayVar = DateTime.parse(
  //         widget.sharedPreferences.getString("selectedCalendarDay"));
  //     removeSelectedCalendarDay();
  //   }
  // }

  // removeSelectedCalendarDay() {
  //   widget.sharedPreferences.remove("selectedCalendarDay");
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations(
  //     [
  //       DeviceOrientation.landscapeLeft,
  //       DeviceOrientation.landscapeRight,
  //     ],
  //   );
  // }

  @override
  dispose() {
    widget.sharedPreferences.remove("selectedDayCalendar");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.database.homeworks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: TableCalendar(
                headerStyle: HeaderStyle(
                    leftChevronVisible: false, rightChevronVisible: false),
                shouldFillViewport: true,
                selectedDayPredicate: (day) {
                  return isSameDay(selectedDayVar, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  selectDay(selectedDay);
                },
                calendarBuilders: CalendarBuilders(
                  outsideBuilder: (context, day, focusedDay) {
                    return CalendarDayColumn(
                      sharedPreferences: widget.sharedPreferences,
                      selectDayFunction: selectDay,
                      deleteFunction: deleteHomework,
                      checkFunction: checkHomework,
                      notifications: widget.notifications,
                      database: widget.database,
                      day: day,
                      homeworks: snapshot.data,
                    );
                  },
                  selectedBuilder: (context, day, focusedDay) {
                    return CalendarDayColumn(
                      sharedPreferences: widget.sharedPreferences,
                      selectDayFunction: selectDay,
                      deleteFunction: deleteHomework,
                      checkFunction: checkHomework,
                      notifications: widget.notifications,
                      database: widget.database,
                      day: day,
                      selected: true,
                      homeworks: snapshot.data,
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return CalendarDayColumn(
                      sharedPreferences: widget.sharedPreferences,
                      selectDayFunction: selectDay,
                      deleteFunction: deleteHomework,
                      checkFunction: checkHomework,
                      notifications: widget.notifications,
                      database: widget.database,
                      homeworks: snapshot.data,
                      day: day,
                      today: true,
                    );
                  },
                  headerTitleBuilder: (context, day) {
                    int nothing = 0;
                    int normal = 0;
                    int medium = 0;
                    int high = 0;
                    if (isSameDay(day, focusedDayVar)) {
                      snapshot.data.forEach(
                        (homework) {
                          if (isSameDay(day, homework.dueDate) &&
                              !homework.done) {
                            if (homework.priority == 0) {
                              nothing++;
                            } else if (homework.priority == 1) {
                              normal++;
                            } else if (homework.priority == 2) {
                              medium++;
                            } else if (homework.priority == 3) {
                              high++;
                            }
                          }
                        },
                      );
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Text("${high == 0 ? "- " : "$high "}"),
                              CircleColor(
                                  color: Homework.priorityColorMap.values
                                      .toList()[3],
                                  circleSize: 15),
                              SizedBox(width: 8),
                              Text("${medium == 0 ? "- " : "$medium "}"),
                              CircleColor(
                                  color: Homework.priorityColorMap.values
                                      .toList()[2],
                                  circleSize: 15),
                              SizedBox(width: 8),
                              Text("${normal == 0 ? "- " : "$normal "}"),
                              CircleColor(
                                  color: Homework.priorityColorMap.values
                                      .toList()[1],
                                  circleSize: 15),
                              SizedBox(width: 8),
                              Text("${nothing == 0 ? "- " : "$nothing "}"),
                              CircleColor(
                                  color: Homework.priorityColorMap.values
                                      .toList()[0],
                                  circleSize: 15),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            toBeginningOfSentenceCase(
                              DateFormat("MMMM y").format(day),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  disabledBuilder: (context, day, focusedDay) {
                    return Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              day.day.toString(),
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 15), //
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                          flex: 5,
                        )
                      ],
                    );
                  },
                  dowBuilder: (_, day) {
                    return Center(
                      child: Text(
                        DateFormat("E").format(day),
                        style: (day.isAfter(DateTime.now()))
                            ? (day.isAfter(DateTime.parse(widget.sharedPreferences.getString("firstTermBeginingDate"))) || isSameDay(day, DateTime.parse(widget.sharedPreferences.getString("firstTermBeginingDate")))) &&
                                    (day.isBefore(DateTime.parse(widget.sharedPreferences.getString("secondTermEndingDate"))) ||
                                        isSameDay(
                                            day,
                                            DateTime.parse(widget
                                                .sharedPreferences
                                                .getString(
                                                    "secondTermEndingDate"))))
                                ? TextStyle(color: Colors.black)
                                : TextStyle(color: Colors.grey)
                            : (day.isAfter(DateTime.parse(widget.sharedPreferences.getString("firstTermBeginingDate"))) ||
                                        isSameDay(
                                            day,
                                            DateTime.parse(widget
                                                .sharedPreferences
                                                .getString(
                                                    "firstTermBeginingDate")))) &&
                                    (day.isBefore(DateTime.parse(widget.sharedPreferences.getString("secondTermEndingDate"))) ||
                                        isSameDay(
                                            day, DateTime.parse(widget.sharedPreferences.getString("secondTermEndingDate"))))
                                ? TextStyle(color: Colors.red)
                                : TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                  defaultBuilder: (context, day, focusedDay) {
                    return CalendarDayColumn(
                      sharedPreferences: widget.sharedPreferences,
                      selectDayFunction: selectDay,
                      deleteFunction: deleteHomework,
                      day: day,
                      checkFunction: checkHomework,
                      homeworks: snapshot.data,
                      database: widget.database,
                      notifications: widget.notifications,
                    );
                  },
                ),
                availableCalendarFormats: {CalendarFormat.week: "Semaine"},
                calendarFormat: CalendarFormat.week,
                startingDayOfWeek: StartingDayOfWeek.monday,
                focusedDay: focusedDayVar ??
                    (DateTime.now().isAfter(
                      DateTime.parse(
                        widget.sharedPreferences
                            .getString("firstTermBeginingDate"),
                      ),
                    )
                        ? DateTime.now().isBefore(
                            DateTime.parse(
                              widget.sharedPreferences
                                  .getString("secondTermEndingDate"),
                            ),
                          )
                            ? DateTime.now()
                            : DateTime.parse(
                                widget.sharedPreferences
                                    .getString("secondTermEndingDate"),
                              )
                        : DateTime.parse(
                            widget.sharedPreferences
                                .getString("firstTermBeginingDate"),
                          )), //Montrer bonne semaine
                firstDay: DateTime.parse(
                  widget.sharedPreferences.getString("firstTermBeginingDate"),
                ),
                lastDay: DateTime.parse(
                  widget.sharedPreferences.getString("secondTermEndingDate"),
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
