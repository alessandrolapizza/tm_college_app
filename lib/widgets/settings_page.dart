import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/modular_app_bar.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        hideSettingsButton: true,
        backArrow: true,
        centerTitle: true,
        title: Text("Paramètres"),
      ),
    );
  }
}
