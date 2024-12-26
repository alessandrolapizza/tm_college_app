import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "./edit_grade_dialog.dart";
import "../models/my_database.dart";
import "../models/subject.dart";
import "./modular_app_bar.dart";
import "./modular_floating_action_button.dart";
import "./theme_controller.dart";
import "./view_average_body.dart";

class ViewAverageScreen extends StatefulWidget {
  final MyDatabase database;

  final SharedPreferences sharedPreferences;

  ViewAverageScreen({
    required this.database,
    required this.sharedPreferences,
  });

  @override
  State<ViewAverageScreen> createState() => _ViewAverageScreenState();
}

class _ViewAverageScreenState extends State<ViewAverageScreen> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final Subject subject = arguments[0];
    final int index = arguments[1];
    return ThemeController(
      color: subject.color,
      child: Scaffold(
        floatingActionButton: ModularFloatingActionButton(
          onPressedFunction: () => showDialog(
            context: context,
            builder: (_) {
              return ThemeController(
                color: subject.color,
                child: EditGradeDialog(
                  sharedPreferences: widget.sharedPreferences,
                  database: widget.database,
                  subjects: [subject],
                  singleSubject: true,
                ),
              );
            },
          ).then((_) => setState(() {})),
          icon: Icons.add_rounded,
        ),
        appBar: ModularAppBar(
          hideSettingsButton: true,
          backArrow: true,
          title: Text("Détails de la moyenne"),
        ),
        body: ViewAverageBody(
          index: index,
          subject: subject,
          database: widget.database,
          sharedPreferences: widget.sharedPreferences,
        ),
      ),
    );
  }
}
