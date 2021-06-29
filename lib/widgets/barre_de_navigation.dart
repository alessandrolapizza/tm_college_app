import "package:flutter/material.dart";

class BottomBar extends StatelessWidget {
  final Function changeIndex;
  final int indexSelected;

  BottomBar({
    @required this.changeIndex,
    @required this.indexSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.school_rounded),
          label: "Devoirs",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_rounded),
          label: "Paramètres",
        ),
      ],
      currentIndex: indexSelected,
      onTap: (int index) => changeIndex(index),
    );
  }
}
