import "package:flutter/material.dart";
import "package:sortedmap/sortedmap.dart";
import "package:intl/intl.dart";
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/empty_centered_text.dart';
import 'package:tm_college_app/widgets/modular_icon_button.dart';
import 'package:tm_college_app/widgets/modular_sticky_header.dart';

import "./carte_devoir.dart";
import "../models/devoir.dart";
import "../models/base_de_donnees.dart";

class HomeworksList extends StatefulWidget {
  final BaseDeDonnees db;

  final bool homePage;

  final Notifications notifications;

  HomeworksList({
    @required this.db,
    @required this.homePage,
    @required this.notifications,
  });

  @override
  _HomeworksList createState() => _HomeworksList();
}

class _HomeworksList extends State<HomeworksList> {
  final ScrollController _scrollControllerHomeworks = ScrollController();

  void checkHomework(
    Devoir homework,
  ) async {
    await Devoir.homeworkChecker(
      homework: homework,
      db: widget.db,
      notifications: widget.notifications,
    );
    setState(() {});
    double offset = _scrollControllerHomeworks.offset;
    _scrollControllerHomeworks.animateTo(
      offset + 0.5,
      duration: Duration(milliseconds: 1),
      curve: Curves.bounceIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.db.homeworks(),
      builder: (_, snapshot) {
        var child;
        if (snapshot.hasData) {
          Map<DateTime, List<Devoir>> homeworksDateMapDone = {};
          Map<DateTime, List<Devoir>> homeworksDateMapToDo = {};
          SortedMap<Comparable<DateTime>, List<Devoir>>
              homeworksDateMapDoneSorted = SortedMap(Ordering.byKey());
          SortedMap<Comparable<DateTime>, List<Devoir>>
              homeworksDateMapToDoSorted = SortedMap(Ordering.byKey());

          snapshot.data.forEach(
            (Devoir homework) {
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

          SortedMap<Comparable<DateTime>, List<Devoir>> homeworks =
              widget.homePage
                  ? homeworksDateMapToDoSorted
                  : homeworksDateMapDoneSorted;

          if (homeworks.length == 0) {
            if (!widget.homePage) {
              child = EmptyCenteredText(content: "Aucun devoirs complétés pour le moment.");
            } else {
              child = EmptyCenteredText(
                  content:
                      "Auncun devoirs pour le moment.\nPour créer un devoir, clique sur le +");
            }
          } else {
            child = ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _scrollControllerHomeworks,
              itemCount: homeworks.length,
              itemBuilder: (_, index) {
                return ModularStickyHeader(
                  content: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: homeworks.values.toList()[index].length,
                    itemBuilder: (_, idx) {
                      return CarteDevoir(
                        devoir: homeworks.values.toList()[index][idx],
                        onTapFunction: () => Navigator.pushNamed(
                          context,
                          "/view_homework_screen",
                          arguments: [
                            homeworks.values.toList()[index][idx],
                            widget.homePage,
                          ],
                        ).then((_) => setState(() {})),
                        actionButton: widget.homePage
                            ? ModularIconButton(
                                color: Colors.green,
                                onPressedFunction: () => checkHomework(
                                  homeworks.values.toList()[index][idx],
                                ),
                                icon: Icons.check_rounded,
                              )
                            : ModularIconButton(
                                color: Colors.orangeAccent,
                                onPressedFunction: () => checkHomework(
                                  homeworks.values.toList()[index][idx],
                                ),
                                icon: Icons.settings_backup_restore_rounded,
                              ),
                      );
                    },
                  ),
                  header: Text(
                    DateFormat("EEEE d MMMM").format(
                      homeworks.keys.toList()[index],
                    ),
                    style: TextStyle(
                        color: DateTime.now().isAfter(
                          homeworks.keys.toList()[index],
                        )
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
