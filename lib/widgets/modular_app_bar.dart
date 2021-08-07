import "package:flutter/material.dart";

class ModularAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  final List<IconButton> actions;

  final bool centerTitle;

  ModularAppBar({
    this.title,
    this.actions,
    this.centerTitle,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: centerTitle,
      actions: actions,
    );
  }
}
