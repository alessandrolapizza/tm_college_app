import 'package:flutter/material.dart';

import 'barre_de_navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  void _pointeurAction(ctx) {
    if (_indexSelected == 0) {
      print("rien pour l'instant");
    } else if (_indexSelected == 1) {
      _creerMatiere(ctx);
    }
  }

  void _creerMatiere(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return Column(children: [],);
      },
    );
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
          onPressed: () => _pointeurAction(context),
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
