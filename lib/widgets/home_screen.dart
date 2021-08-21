import "package:flutter/material.dart";

import 'package:tm_college_app/widgets/home_screen_bottom_app_bar.dart';
import 'package:tm_college_app/widgets/modular_icon_button.dart';
import "./modular_app_bar.dart";
import 'homeworks_list.dart';
import "./modular_floating_action_button.dart";
import 'home_screen_body_subjects.dart';
import "../models/base_de_donnees.dart";

class HomeScreen extends StatefulWidget {
  final BaseDeDonnees db;

  HomeScreen(this.db);

  @override
  _HomeScreenState createState() => _HomeScreenState(db);
}

class _HomeScreenState extends State<HomeScreen> {
  final BaseDeDonnees db;

  _HomeScreenState(this.db);

  var _index = 0;

  void _changeIndex(index) => setState(() => _index = index);

  String get _title {
    String text;

    if (_index == 0) {
      text = "Devoirs";
    } else {
      text = "Matières";
    }

    return text;
  }

  Widget get _homePageBody {
    Widget body;

    if (_index == 0) {
      body = HomeworksList(
        db: db,
        homePage: true,
      );
    } else {
      body = HomeScreenBodySubjects(db);
    }

    return body;
  }

  void _routePointer() {
    if (_index == 0) {
      Navigator.pushNamed(context, "/edit_homework_screen",
          arguments: [null, true]).then((_) => setState(() {}));
    } else if (_index == 1) {
      Navigator.pushNamed(context, "/create_subject_screen")
          .then((_) => setState(() {}));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFEFEFF4),
      appBar: ModularAppBar(
        actions: _index == 0
            ? [
                ModularIconButton(
                  onPressedFunction: () =>
                      Navigator.pushNamed(context, "/done_homeworks_screen")
                          .then((_) => setState(() {})),
                  icon: Icons.checklist,
                )
              ]
            : null,
        title: Text(_title),
        centerTitle: false,
      ),
      body: _homePageBody,
      floatingActionButton: ModularFloatingActionButton(
        onPressedFunction: _routePointer,
        icon: Icons.add,
      ),
      bottomNavigationBar: HomePageBottomAppBar(
        changerIndex: _changeIndex,
        indexSelectionne: _index,
      ),
    );
  }
}
