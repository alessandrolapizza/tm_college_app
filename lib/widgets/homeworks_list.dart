import "package:flutter/material.dart";
import "package:intl/intl.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "package:sortedmap/sortedmap.dart";
import "../models/homework.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "./empty_centered_text.dart";
import "./homework_card.dart";
import "./modular_sticky_header.dart";

class HomeworksList extends StatefulWidget {
  final MyDatabase database;

  final bool homePage;

  final Notifications notifications;

  final SharedPreferences sharedPreferences;

  final ScrollController scrollControllerHomeworks;

  HomeworksList({
    @required this.database,
    @required this.homePage,
    @required this.notifications,
    @required this.sharedPreferences,
    @required this.scrollControllerHomeworks,
  });

  @override
  _HomeworksList createState() => _HomeworksList();
}

class _HomeworksList extends State<HomeworksList> {
  void _checkHomework(
    Homework homework,
  ) async {
    await Homework.homeworkChecker(
      homework: homework,
      database: widget.database,
      notifications: widget.notifications,
    );
    setState(() {});
    double offset = widget.scrollControllerHomeworks.offset;
    widget.scrollControllerHomeworks.animateTo(
      offset + 0.5,
      duration: Duration(milliseconds: 1),
      curve: Curves.bounceIn,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(homework.done
            ? "Devoir marqué comme \"non fait\"."
            : "Devoir marqué comme \"complété\"."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.database.homeworks(),
      builder: (_, snapshot) {
        var child;
        if (snapshot.hasData) {
          Map<DateTime, List<Homework>> homeworksDateMapDone = {};
          Map<DateTime, List<Homework>> homeworksDateMapToDo = {};
          SortedMap<Comparable<DateTime>, List<Homework>>
              homeworksDateMapDoneSorted = SortedMap(Ordering.byKey());
          SortedMap<Comparable<DateTime>, List<Homework>>
              homeworksDateMapToDoSorted = SortedMap(Ordering.byKey());

          snapshot.data.forEach(
            (Homework homework) {
              if (!homework.done) {
                if (homeworksDateMapToDo.containsKey(homework.dueDate)) {
                  homeworksDateMapToDo[homework.dueDate].add(homework);
                } else {
                  homeworksDateMapToDo[homework.dueDate] = [homework];
                }
              } else {
                if (homeworksDateMapDone.containsKey(homework.dueDate)) {
                  homeworksDateMapDone[homework.dueDate].add(homework);
                } else {
                  homeworksDateMapDone[homework.dueDate] = [homework];
                }
              }
            },
          );

          if (homeworksDateMapDone != null) {
            homeworksDateMapDoneSorted.addAll(homeworksDateMapDone);
          }

          if (homeworksDateMapToDo != null) {
            homeworksDateMapToDoSorted.addAll(homeworksDateMapToDo);
          }

          SortedMap<Comparable<DateTime>, List<Homework>> homeworks =
              widget.homePage
                  ? homeworksDateMapToDoSorted
                  : homeworksDateMapDoneSorted;

          if (homeworks.length == 0) {
            if (!widget.homePage) {
              child = EmptyCenteredText(
                  content: "Aucun devoir complété pour le moment.");
            } else {
              child = EmptyCenteredText(
                  content:
                      "Aucun devoir pour le moment.\nPour créer un devoir, clique sur le +");
            }
          } else {
            child = ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: widget.scrollControllerHomeworks,
              itemCount: homeworks.length,
              itemBuilder: (_, index) {
                index =
                    widget.homePage ? index : homeworks.length - (index + 1);
                return ModularStickyHeader(
                  content: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: homeworks.values.toList()[index].length,
                    itemBuilder: (_, idx) {
                      return HomeworkCard(
                        sharedPreferences: widget.sharedPreferences,
                        homework: homeworks.values.toList()[index][idx],
                        onTapFunction: () => Navigator.pushNamed(
                          context,
                          "/view_homework_screen",
                          arguments: [
                            homeworks.values.toList()[index][idx],
                            widget.homePage,
                          ],
                        ).then((_) {
                          double offset =
                              widget.scrollControllerHomeworks.offset;
                          widget.scrollControllerHomeworks.animateTo(
                            offset + 0.5,
                            duration: Duration(milliseconds: 1),
                            curve: Curves.bounceIn,
                          );
                          //setState(() {});
                        }),
                        actionButton: widget.homePage
                            ? FittedBox(
                                child: TextButton(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      ),
                                      Text(
                                        "Valider",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  onPressed: () => _checkHomework(
                                    homeworks.values.toList()[index][idx],
                                  ),
                                ),
                              )
                            : FittedBox(
                                child: TextButton(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.published_with_changes_rounded,
                                        color: Colors.orangeAccent,
                                      ),
                                      Text(
                                        "Invalider",
                                        style: TextStyle(
                                            color: Colors.orangeAccent),
                                      ),
                                    ],
                                  ),
                                  onPressed: () => _checkHomework(
                                    homeworks.values.toList()[index][idx],
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                  header: Text(
                    (homeworks.keys.toList()[index] as DateTime) ==
                            DateTime(DateTime.now().year, DateTime.now().month,
                                DateTime.now().day - 2)
                        ? "Avant-hier (${DateFormat("EEEE d MMMM").format(homeworks.keys.toList()[index])})"
                        : (homeworks.keys.toList()[index] as DateTime) ==
                                DateTime(
                                    DateTime.now().year,
                                    DateTime.now().month,
                                    DateTime.now().day - 1)
                            ? "Hier (${DateFormat("EEEE d MMMM").format(homeworks.keys.toList()[index])})"
                            : (homeworks.keys.toList()[index] as DateTime) ==
                                    DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day)
                                ? "Aujourd'hui (${DateFormat("EEEE d MMMM").format(homeworks.keys.toList()[index])})"
                                : (homeworks.keys.toList()[index]
                                            as DateTime) ==
                                        DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day + 1)
                                    ? "Demain (${DateFormat("EEEE d MMMM").format(homeworks.keys.toList()[index])})"
                                    : (homeworks.keys.toList()[index]
                                                as DateTime) ==
                                            DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day + 2)
                                        ? "Après-demain (${DateFormat("EEEE d MMMM").format(homeworks.keys.toList()[index])})"
                                        : DateFormat("EEEE d MMMM").format(
                                            homeworks.keys.toList()[index]),
                    style: TextStyle(
                        color: DateTime.now()
                                .isAfter(homeworks.keys.toList()[index])
                            ? Colors.red
                            : Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
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
