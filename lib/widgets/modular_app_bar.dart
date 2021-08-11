import "package:flutter/material.dart";
import "./modular_icon_button.dart";

class ModularAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  final List<ModularIconButton> actions;

  final bool centerTitle;

  final bool backArrow;

  ModularAppBar({
    this.title,
    this.actions,
    this.centerTitle,
    this.backArrow = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: backArrow
          ? ModularIconButton(
              icon: Icons.arrow_back_ios_new,
              onPressedFunction: () => Navigator.pop(context),
            )
          : null,
      title: Text(title),
      centerTitle: centerTitle,
      actions: actions,
    );
  }
}
