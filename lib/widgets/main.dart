import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:intl/date_symbol_data_local.dart';

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

  await initializeDateFormatting();

  Intl.defaultLocale = "fr";

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
      ),
      body: _indexSelectionne == 0
          ? FutureBuilder(
              future: bD.homeworks(),
              builder: (_, snapshot) {
                var children;
                if (snapshot.hasData) {
                  children = ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      debugPrint(snapshot.data[index].id);
                      return CarteDevoir(snapshot.data[index]);
                    },
                  );
                } else {
                  children = Center(child: CircularProgressIndicator());
                }
                return children;
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
