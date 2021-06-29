import 'package:flutter/material.dart';
import "package:intl/intl.dart";

import 'bottombar.dart';

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
      _resultText = "Paramètres";
    }
    return _resultText;
  }

  void _changeIndex(index) {
    setState(() {
      _indexSelected = index;
      print(index);
    });
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
            InkWell(
              onTap: () {},
              child: Container(
                height: 90,
                width: double.infinity,
                child: Card(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Card(
                          color: Colors.red, // à construire
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.orangeAccent, //à construire
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 0.1,
                            ),
                          ),
                          child: Icon(
                            Icons.calculate, // à construire
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 13,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Text(
                                "Mathématiques", // à construire
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 3),
                                child: Text(
                                  "overflowoverflowoverflowoverflowoverflowoverflowoverflowoverflowoverflowoverflowoverflowoverflowoverflow", // à construire
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.check),
                            color: Colors.green,
                            splashRadius: 20,
                          ),
                        ),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: _indexSelected == 0
            ? FloatingActionButton(
                onPressed: () => {},
                child: Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: BottomBar(
          changeIndex: _changeIndex,
          indexSelected: _indexSelected,
        ),
      ),
    );
  }
}
