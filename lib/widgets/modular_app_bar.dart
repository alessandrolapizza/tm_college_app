import "package:flutter/material.dart";
import "./modular_icon_button.dart";

class ModularAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Text? title;

  final List<ModularIconButton>? actions;

  final bool? centerTitle;

  final bool backArrow;

  final bool hideSettingsButton;

  ModularAppBar({
    this.title,
    this.actions,
    this.centerTitle,
    this.backArrow = false,
    this.hideSettingsButton = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    ModularIconButton settingAction = ModularIconButton(
      onPressedFunction: () => Navigator.pushNamed(context, "/settings_screen"),
      icon: Icons.settings_rounded,
    );
    List<ModularIconButton>? actionsWithSettings;
    if (actions == null && !hideSettingsButton) {
      actionsWithSettings = [settingAction];
    } else if (!hideSettingsButton) {
      actions!.add(settingAction);
      actionsWithSettings = actions;
    } else {
      actionsWithSettings = actions;
    }
    return AppBar(
      leading: backArrow
          ? ModularIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressedFunction: () => Navigator.pop(context),
            )
          : null,
      title: title,
      centerTitle: centerTitle,
      actions: actionsWithSettings,
    );
  }
}
