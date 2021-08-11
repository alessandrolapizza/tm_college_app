import "package:flutter/material.dart";

import 'package:tm_college_app/widgets/home_page_bottom_app_bar.dart';
import 'package:tm_college_app/widgets/modular_icon_button.dart';
import "./modular_app_bar.dart";
import "./home_page_body_homeworks.dart";
import "./modular_floating_action_button.dart";
import "./home_page_body_subjects.dart";
import "../models/base_de_donnees.dart";

class HomePage extends StatefulWidget {
  final BaseDeDonnees db;

  HomePage(this.db);

  @override
  _HomePageState createState() => _HomePageState(db);
}

class _HomePageState extends State<HomePage> {
  final BaseDeDonnees db;

  _HomePageState(this.db);

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
      body = HomePageBodyHomeworks(db);
    } else {
      body = HomePageBodySubjects(db);
    }

    return body;
  }

  void _routePointer() {
    if (_index == 0) {
      Navigator.pushNamed(context, "/create_homework_page")
          .then((_) => setState(() {}));
    } else if (_index == 1) {
      Navigator.pushNamed(context, "/create_subject_page")
          .then((_) => setState(() {}));
    }
    print("test");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        actions: _index == 0
            ? [
                ModularIconButton(
                  onPressedFunction: () {},
                  icon: Icons.checklist,
                )
              ]
            : null,
        title: _title,
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
