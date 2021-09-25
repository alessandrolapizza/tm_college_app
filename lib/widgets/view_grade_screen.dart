import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/models/matiere.dart';
import 'package:tm_college_app/widgets/edit_grade_dialog.dart';
import 'package:tm_college_app/widgets/modular_app_bar.dart';
import 'package:tm_college_app/widgets/modular_floating_action_button.dart';
import 'package:tm_college_app/widgets/theme_controller.dart';
import 'package:tm_college_app/widgets/view_grade_body.dart';

class ViewGradeScreen extends StatefulWidget {
  final BaseDeDonnees database;

  final SharedPreferences sharedPreferences;

  ViewGradeScreen({
    @required this.database,
    @required this.sharedPreferences,
  });

  @override
  State<ViewGradeScreen> createState() => _ViewGradeScreenState();
}

class _ViewGradeScreenState extends State<ViewGradeScreen> {

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;
    final Matiere subject = arguments[0];
    final int index = arguments[1];
    return ThemeController(
      color: subject.couleurMatiere,
      child: Scaffold(
        floatingActionButton: ModularFloatingActionButton(
            onPressedFunction: () => showDialog(
                  context: context,
                  builder: (_) {
                    return ThemeController(
                      color: subject.couleurMatiere,
                      child: EditGradeDialog(
                        sharedPreferences: widget.sharedPreferences,
                        database: widget.database,
                        subjects: [subject],
                        singleSubject: true,
                      ),
                    );
                  },
                ).then((_) => setState(() {})),
            icon: Icons.add),
        appBar: ModularAppBar(
          hideSettingsButton: true,
          backArrow: true,
          title: Text("Détails de la moyenne"),
        ),
        body: ViewGradeBody(
          index: index,
          subject: subject,
          database: widget.database,
          sharedPreferences: widget.sharedPreferences,
        ),
      ),
    );
  }
}
