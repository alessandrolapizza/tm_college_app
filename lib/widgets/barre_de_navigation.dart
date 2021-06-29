import "package:flutter/material.dart";

class BarreDeNavigation extends StatelessWidget {
  final Function changeIndex;
  final int indexSelected;

  BarreDeNavigation({
    @required this.changeIndex,
    @required this.indexSelected,
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
          label: "Matières"
        ),
      ],
      currentIndex: indexSelected,
      onTap: (int index) => changeIndex(index),
    );
  }
}
