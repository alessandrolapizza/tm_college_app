import "package:flutter/material.dart";

import "package:sortedmap/sortedmap.dart";
import 'package:sticky_headers/sticky_headers/widget.dart';
import "package:intl/intl.dart";
import 'package:tm_college_app/widgets/modular_icon_button.dart';

import "./carte_devoir.dart";
import "../models/devoir.dart";
import "../models/base_de_donnees.dart";

class HomeworksList extends StatefulWidget {
  final BaseDeDonnees db;

  final bool homePage;

  HomeworksList({
    @required this.db,
    @required this.homePage,
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

          debugPrint(homeworksDateMapDoneSorted.toString());

          SortedMap<Comparable<DateTime>, List<Devoir>> homeworks =
              widget.homePage
                  ? homeworksDateMapToDoSorted
                  : homeworksDateMapDoneSorted;

          child = homeworks.length == 0
              ? Text("test")
              : ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollControllerHomeworks,
                  itemCount: homeworks.length,
                  itemBuilder: (_, index) {
                    return StickyHeader(
                      header: Container(
                          height: 30,
                          width: double.infinity,
                          child: Material(
                            elevation: 1.5,
                            child: Container(
                              color: Colors.grey[50],
                              child: Center(
                                child: Text(
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
                              ),
                            ),
                          )),
                      content: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: homeworks.values.toList()[index].length,
                        itemBuilder: (_, idx) {
                          return CarteDevoir(
                            devoir: homeworks.values.toList()[index][idx],
                            onTapFunction: () => Navigator.pushNamed(
                              context,
                              "/homework_details_page",
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
                                    icon: Icons.check,
                                  )
                                : ModularIconButton(
                                    color: Colors.orange,
                                    onPressedFunction: () => checkHomework(
                                      homeworks.values.toList()[index][idx],
                                    ),
                                    icon: Icons.settings_backup_restore,
                                  ),
                          );
                        },
                      ),
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
