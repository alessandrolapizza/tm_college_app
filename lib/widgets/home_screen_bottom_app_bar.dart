import "package:flutter/material.dart";

class HomePageBottomAppBar extends StatelessWidget {
  final Function changerIndex;
  final int indexSelectionne;

  HomePageBottomAppBar({
    @required this.changerIndex,
    @required this.indexSelectionne,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.fact_check_rounded),
          label: "Devoirs",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment_rounded),
          label: "Moyennes",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.table_rows_rounded),
          label: "Matières",
        ),
      ],
      currentIndex: indexSelectionne,
      onTap: (int index) => changerIndex(index),
    );
  }
}
