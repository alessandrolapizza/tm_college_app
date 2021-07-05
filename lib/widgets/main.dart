import 'package:flutter/material.dart';

import "./page_creer_devoir.dart";
import "./page_creer_matiere.dart";
import './barre_navigation.dart';
import './carte_devoir.dart';
import "../models/matiere.dart";
import "../models/devoir.dart";
import '../models/base_de_donnees.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  BaseDeDonnees bD = BaseDeDonnees();

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
        "/": (context) => PageAccueil(),
        "/page_creer_matiere": (context) => PageCreerMatiere(),
        "/page_creer_devoir": (context) => PageCreerDevoir(),
      },
    );
  }
}

class PageAccueil extends StatefulWidget {
  @override
  _PageAccueilState createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  var _indexSelected = 0;

  String get _textToShow {
    String _resultText;
    if (_indexSelected == 0) {
      _resultText = "Devoirs";
    } else {
      _resultText = "Matières";
    }
    return _resultText;
  }

  void _changeIndex(index) {
    setState(() {
      _indexSelected = index;
      print(index);
    });
  }

  void _pointeurAction() {
    if (_indexSelected == 0) {
      Navigator.pushNamed(context, "/page_creer_devoir");
    } else if (_indexSelected == 1) {
      Navigator.pushNamed(context, "/page_creer_matiere");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_textToShow),
      ),
      body: Column(
        children: [
          //Changer conditions d'apparitions
          CarteDevoir(
            Devoir(
              contenu:
                  "test 123455555 overflow overflow overflow overflow overflow overflow",
              id: 1,
              dateLimite: DateTime.now(),
              matiere: Matiere(
                couleurMatiere: Colors.red,
                iconMatiere: Icons.calculate,
                id: 2,
                nom: "Mathématiques",
              ),
              importance: 1,
            ),
          )
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return FloatingActionButton(
            onPressed: () => _pointeurAction(),
            child: Icon(Icons.add),
          );
        },
      ),
      bottomNavigationBar: BarreNavigation(
        changeIndex: _changeIndex,
        indexSelected: _indexSelected,
      ),
    );
  }
}
