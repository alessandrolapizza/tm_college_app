import 'package:flutter/material.dart';
import "package:intl/intl.dart";

import 'barre_de_navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      print("rien pour l'instant"); 
    } else if (_indexSelected == 1) {
      //mettre la fonction ici.
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(_textToShow),
        ),
        body: Column(
          children: [
            //devoirs
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _pointeurAction(),
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: BarreDeNavigation(
          changeIndex: _changeIndex,
          indexSelected: _indexSelected,
        ),
      ),
    );
  }
}
