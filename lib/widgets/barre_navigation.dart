import "package:flutter/material.dart";

class BarreNavigation extends StatelessWidget {
  final Function changerIndex;
  final int indexSelectionne;

  BarreNavigation({
    @required this.changerIndex,
    @required this.indexSelectionne,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books_rounded),
          label: "Devoirs",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school_rounded),
          label: "Matières",
        ),
      ],
      currentIndex: indexSelectionne,
      onTap: (int index) => changerIndex(index),
    );
  }
}
