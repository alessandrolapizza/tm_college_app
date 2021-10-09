import "package:flutter/material.dart";
import './app.dart';

class HomePageBottomAppBar extends StatelessWidget {
  final Function changeIndexFunction;

  final int indexSelectionne;

  HomePageBottomAppBar({
    @required this.changeIndexFunction,
    @required this.indexSelectionne,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.fact_check_rounded),
          label: "Devoirs",
          tooltip: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment_rounded),
          label: "Moyennes",
          tooltip: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_rows_rounded),
          label: "Matières",
          tooltip: "",
        ),
      ],
      currentIndex: indexSelectionne,
      onTap: (int index) => changeIndexFunction(index),
    );
  }
}
