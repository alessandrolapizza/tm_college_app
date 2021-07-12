import 'package:flutter/material.dart';

import "./page_visualiser_matiere.dart";
import "./page_creer_devoir.dart";
import "./page_creer_matiere.dart";
import './barre_navigation.dart';
import './carte_devoir.dart';
import "./carte_matiere.dart";
import "../models/matiere.dart";
import "../models/devoir.dart";
import '../models/base_de_donnees.dart';

BaseDeDonnees bD;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  bD = BaseDeDonnees();

  bD.defCheminMatieres();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TM_COLLEGE_APP", //Provisoire
      initialRoute: "/",
      routes: {
        "/": (_) => PageAccueil(),
        "/page_creer_matiere": (_) => PageCreerMatiere(bD),
        "/page_creer_devoir": (_) => PageCreerDevoir(bD),
        "/page_visualiser_matiere": (_) => PageVisualiserMatiere(),
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
      Navigator.pushNamed(context, "/page_creer_devoir");
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
      ),
      body: Column(
        children: _indexSelectionne == 0
            ? [
                CarteDevoir(
                  Devoir(
                    contenu:
                        "test 123455555 overflow overflow overflow overflow overflow overflow",
                    id: 1,
                    dateLimite: DateTime.now(),
                    matiere: Matiere(
                      salle: "746",
                      couleurMatiere: Colors.red,
                      iconMatiere: Icons.calculate,
                      nom: "Mathématiques",
                    ),
                    importance: 1,
                  ),
                )
              ]
            : [
                Expanded(
                  child: FutureBuilder(
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
                      }),
                )
              ],
      )

      //Changer conditions d'apparitions
      ,
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
