import 'package:flutter/material.dart';
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:sortedmap/sortedmap.dart";
import 'package:sticky_headers/sticky_headers/widget.dart';
import "package:flutter_localizations/flutter_localizations.dart";
import 'package:tm_college_app/widgets/page_visualiser_devoir.dart';

import "../models/devoir.dart";
import "./page_visualiser_matiere.dart";
import "./page_creer_devoir.dart";
import "./page_creer_matiere.dart";
import './barre_navigation.dart';
import './carte_devoir.dart';
import "./carte_matiere.dart";
import '../models/base_de_donnees.dart';

BaseDeDonnees bD;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bD = BaseDeDonnees();

  await bD.defCheminMatieres();

  Intl.defaultLocale = "fr";

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        Locale(
          "fr",
          "FR",
        ),
      ],
      title: "TM_COLLEGE_APP", //Provisoire
      initialRoute: "/",
      routes: {
        "/": (_) => PageAccueil(),
        "/page_creer_matiere": (_) => PageCreerMatiere(bD),
        "/page_creer_devoir": (_) => PageCreerDevoir(bD),
        "/page_visualiser_matiere": (_) => PageVisualiserMatiere(),
        "/homework_details_page": (_) => HomeworkDetailsPage(),
      },
    );
  }
}

class PageAccueil extends StatefulWidget {
  @override
  _PageAccueilState createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  var _indexSelectionne = 0;

  String get _texteAAfficher {
    String _resultText;
    if (_indexSelectionne == 0) {
      _resultText = "Devoirs";
    } else {
      _resultText = "Matières";
    }
    return _resultText;
  }

  void _changerIndex(index) {
    setState(() {
      _indexSelectionne = index;
      print(index);
    });
  }

  void _pointeurAction() {
    if (_indexSelectionne == 0) {
      Navigator.pushNamed(context, "/page_creer_devoir")
          .then((_) => setState(() {}));
    } else if (_indexSelectionne == 1) {
      Navigator.pushNamed(context, "/page_creer_matiere")
          .then((_) => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_texteAAfficher),
        centerTitle: false,
      ),

      body: _indexSelectionne == 0
          ? FutureBuilder(
              future: bD.homeworks(),
              builder: (_, snapshot) {
                var child;
                if (snapshot.hasData) {
                  Map<DateTime, List<Devoir>> homeworksDateMap = {};
                  Map<DateTime, List<Devoir>> homeworksDateMapToDo = {};
                  SortedMap<Comparable<DateTime>, List<Devoir>>
                      homeworksDateMapSorted = SortedMap(Ordering.byKey());
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
                        if (homeworksDateMapToDo
                            .containsKey(homework.dueDate)) {
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
                                                      homeworksDateMapToDoSorted
                                                          .keys
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
                                  debugPrint(homeworksDateMapToDoSorted.values
                                      .toList()
                                      .toString());
                                  debugPrint(homeworksDateMapToDoSorted.values
                                      .toList()
                                      .length
                                      .toString());
                                  return CarteDevoir(homeworksDateMapToDoSorted
                                      .values
                                      .toList()[index][idx]);
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
            )
          : FutureBuilder(
              future: bD.matieres(),
              builder: (_, snapshot) {
                var children;
                if (snapshot.hasData) {
                  children = ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      debugPrint(snapshot.data[index].id);
                      return CarteMatiere(snapshot.data[index]);
                    },
                  );
                } else {
                  children = Center(child: CircularProgressIndicator());
                }
                return children;
              },
            ),

      //Changer conditions d'apparitions

      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () => _pointeurAction(),
            child: Icon(Icons.add),
          );
        },
      ),
      bottomNavigationBar: BarreNavigation(
        changerIndex: _changerIndex,
        indexSelectionne: _indexSelectionne,
      ),
    );
  }
}
