import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/circle_avatar_with_border.dart';
import 'package:tm_college_app/widgets/edit_homework_body.dart';
import 'package:tm_college_app/widgets/fade_gradient.dart';
import 'package:tm_college_app/widgets/modular_app_bar.dart';
import "package:flutter_material_color_picker/flutter_material_color_picker.dart";
import 'package:tm_college_app/widgets/theme_controller.dart';

import "../models/devoir.dart";
import "../models/matiere.dart";
import "../models/base_de_donnees.dart";

class EditHomeworkPage extends StatefulWidget {
  final BaseDeDonnees db;

  EditHomeworkPage({@required this.db});

  @override
  _EditHomeworkPageState createState() => _EditHomeworkPageState();
}

class _EditHomeworkPageState extends State<EditHomeworkPage> {
  TextEditingController _homeworkContentController;

  final GlobalKey<FormState> _createHomeworkFormKey = GlobalKey();

  int _selectedPriority;

  Matiere _selectedSubject;

  DateTime _selectedDate;

  bool _dateMissing = false;

  Future<void> _selectSubject() async {
    Matiere subject = await showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: FadeGradient(
            child: FutureBuilder(
              future: widget.db.matieres(),
              builder: (_, snapshot) {
                var children;
                if (snapshot.hasData) {
                  children = SingleChildScrollView(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.length + 1,
                      shrinkWrap: true,
                      itemBuilder: (_, index) {
                        print(index);
                        print(snapshot.data.length);
                        return index != snapshot.data.length
                            ? ListTile(
                                onTap: () => Navigator.pop(
                                    context, snapshot.data[index]),
                                leading: CircleAvatarWithBorder(
                                  color: snapshot.data[index].couleurMatiere,
                                  icon: snapshot.data[index].iconMatiere,
                                ),
                                title: Text(snapshot.data[index].nom),
                              )
                            : ListTile(
                                title: Text(Matiere.noSubject.nom),
                                onTap: () =>
                                    Navigator.pop(context, Matiere.noSubject),
                                leading: CircleAvatarWithBorder(
                                  color: Matiere.noSubject.couleurMatiere,
                                  icon: Matiere.noSubject.iconMatiere,
                                ),
                              );
                      },
                    ),
                  );
                } else {
                  children = Center(child: CircularProgressIndicator());
                }
                return children;
              },
            ),
          ),
        );
      },
    );

    if (subject != null) {
      setState(() => _selectedSubject = subject);
    }
  }

  Future<void> _selectDate() async {
    DateTime date = await showDatePicker(
        cancelText: "Annuler",
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2019), //à construire plus tard.
        lastDate: DateTime(2050),
        builder: (BuildContext context, Widget child) {
          return ThemeController(
            child: child,
            color: _selectedSubject.couleurMatiere,
          );
        } //à construire plus tard.
        );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _selectPriority() async {
    int priority = await showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 4,
              itemBuilder: (_, index) {
                return ListTile(
                  onTap: () => Navigator.pop(context, index),
                  leading: CircleColor(
                    color: Devoir.priorityColorMap.values.toList()[index],
                    circleSize: 40,
                  ),
                  title: Text(
                    Devoir.priorityColorMap.keys.toList()[index],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
    if (priority != null) {
      setState(() => _selectedPriority = priority);
    }
  }

  Future<void> _editHomework(Devoir homework) async {
    bool created = false;
    final Devoir newHomework = Devoir(
      content: _homeworkContentController.text,
      dueDate: _selectedDate,
      subjectId: _selectedSubject.id,
      priority: _selectedPriority,
      done: false,
      subject: _selectedSubject,
      id: homework == null ? null : homework.id,
    );
    if (_createHomeworkFormKey.currentState.validate() &&
        _selectedDate != null) {
      homework == null
          ? await widget.db.insertHomework(
              newHomework,
            )
          : await widget.db.updateHomework(
              newHomework,
            );
      created = true;
    } else {
      if (_selectedDate == null) {
        _dateMissing = true;
      } else {
        _dateMissing = false;
      }
      setState(() => _dateMissing);
      created = false;
    }
    if (created) {
      Navigator.pop(context, [newHomework]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments = ModalRoute.of(context).settings.arguments;
    final Devoir homework = arguments[0];
    final bool newHomework = arguments[1];
    _selectedPriority = _selectedPriority != null
        ? _selectedPriority
        : homework == null
            ? 0
            : homework.priority;
    _homeworkContentController = _homeworkContentController != null
        ? _homeworkContentController
        : homework == null
            ? TextEditingController()
            : TextEditingController(text: homework.content);
    _selectedSubject = _selectedSubject != null
        ? _selectedSubject
        : homework == null
            ? Matiere.noSubject
            : homework.subject;
    _selectedDate = _selectedDate != null
        ? _selectedDate
        : homework == null
            ? null
            : homework.dueDate;
    return ThemeController(
      color: _selectedSubject.couleurMatiere,
      child: Scaffold(
        appBar: ModularAppBar(
          hideSettingsButton: true,
          backArrow: true,
          title: newHomework ? "Nouveau devoir" : "Modifier devoir",
          centerTitle: true,
        ),
        body: EditHomeworkBody(
          selectSubjectFunction: _selectSubject,
          selectedSubject: _selectedSubject,
          homeworkContentController: _homeworkContentController,
          selectDateFunction: _selectDate,
          selectedDate: _selectedDate,
          selectPriorityFunction: _selectPriority,
          selectedPriority: _selectedPriority,
          editHomeworkFunction: () => _editHomework(homework),
          createHomeworkFormKey: _createHomeworkFormKey,
          dateMissing: _dateMissing,
        ),
      ),
    );
  }
}
