import "package:flutter/material.dart";

import "package:sortedmap/sortedmap.dart";
import 'package:sticky_headers/sticky_headers/widget.dart';
import "package:intl/intl.dart";

import "./carte_devoir.dart";
import "../models/devoir.dart";
import "../models/base_de_donnees.dart";

class HomePageBodyHomeworks extends StatefulWidget {
  final BaseDeDonnees db;

  HomePageBodyHomeworks(this.db);

  @override
  _HomePageBodyHomeworksState createState() => _HomePageBodyHomeworksState();
}

class _HomePageBodyHomeworksState extends State<HomePageBodyHomeworks> {
  final ScrollController _scrollControllerHomeworks = ScrollController();

  void checkHomework(
    Devoir homework,
  ) async {
    await Devoir.homeworkChecker(
      homework: homework,
      done: true,
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
          Map<DateTime, List<Devoir>> homeworksDateMap = {};
          Map<DateTime, List<Devoir>> homeworksDateMapToDo = {};
          SortedMap<Comparable<DateTime>, List<Devoir>> homeworksDateMapSorted =
              SortedMap(Ordering.byKey());
          SortedMap<Comparable<DateTime>, List<Devoir>>
              homeworksDateMapToDoSorted = SortedMap(Ordering.byKey());

          snapshot.data.forEach(
            (Devoir homework) {
              if (homeworksDateMap.containsKey(homework.dueDate)) {
                homeworksDateMap[homework.dueDate].add(homework);
              } else {
                homeworksDateMap[homework.dueDate] = [homework];
              }
              if (!homework.done) {
                if (homeworksDateMapToDo.containsKey(homework.dueDate)) {
                  homeworksDateMapToDo[homework.dueDate].add(homework);
                } else {
                  homeworksDateMapToDo[homework.dueDate] = [homework];
                }
              }
            },
          );

          if (homeworksDateMap != null) {
            homeworksDateMapSorted.addAll(homeworksDateMap);
          }

          if (homeworksDateMapToDo != null) {
            homeworksDateMapToDoSorted.addAll(homeworksDateMapToDo);
          }

          //régler ce probleme

          debugPrint(homeworksDateMapSorted.toString());

          child = homeworksDateMapToDoSorted.length == 0
              ? Text("test")
              : ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollControllerHomeworks,
                  itemCount: homeworksDateMapToDoSorted.length,
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
                                    homeworksDateMapToDoSorted.keys
                                        .toList()[index],
                                  ),
                                  style: TextStyle(
                                      color: DateTime.now().isAfter(
                                              homeworksDateMapToDoSorted.keys
                                                  .toList()[index])
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
                        itemCount: homeworksDateMapToDoSorted.values
                            .toList()[index]
                            .length,
                        itemBuilder: (_, idx) {
                          //debugPrint(homeworksDateMapToDoSorted.values
                          //    .toList()
                          //    .toString());
                          //debugPrint(homeworksDateMapToDoSorted.values
                          //    .toList()
                          //    .length
                          //    .toString());
                          return CarteDevoir(
                            devoir: homeworksDateMapToDoSorted.values
                                .toList()[index][idx],
                            onTapFunction: () => Navigator.pushNamed(
                                    context, "/homework_details_page",
                                    arguments: homeworksDateMapToDoSorted.values
                                        .toList()[index][idx])
                                .then((_) => setState(() {})),
                            onCheckFunction: checkHomework,
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
