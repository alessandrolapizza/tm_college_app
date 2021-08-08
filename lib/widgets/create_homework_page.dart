import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/create_homework_body.dart';
import 'package:tm_college_app/widgets/fade_gradient.dart';
import 'package:tm_college_app/widgets/modular_app_bar.dart';
import "package:flutter_material_color_picker/flutter_material_color_picker.dart";

import "../models/devoir.dart";
import "../models/matiere.dart";
import "../models/base_de_donnees.dart";

class CreateHomeworkPage extends StatefulWidget {
  final BaseDeDonnees bD;

  CreateHomeworkPage(this.bD);

  @override
  _CreateHomeworkPageState createState() => _CreateHomeworkPageState(bD);
}

class _CreateHomeworkPageState extends State<CreateHomeworkPage> {
  final BaseDeDonnees _bD;

  _CreateHomeworkPageState(this._bD);

  Matiere _selectedSubject;

  TextEditingController _homeworkContentController = TextEditingController();

  DateTime _selectedDate;

  int _selectedPriority = 0;

  Future<void> _selectSubject() async {
    Matiere subject = await showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: FadeGradient(
            child: FutureBuilder(
              future: _bD.matieres(),
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
                                leading: CircleAvatar(
                                  backgroundColor:
                                      snapshot.data[index].couleurMatiere,
                                  child: Icon(
                                    snapshot.data[index].iconMatiere,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(snapshot.data[index].nom),
                              )
                            : ListTile(
                                onTap: () =>
                                    Navigator.pop(context, Matiere.noSubject),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      Matiere.noSubject.couleurMatiere,
                                  child: Icon(
                                    Matiere.noSubject.iconMatiere,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(Matiere.noSubject.nom),
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
    _selectedDate = await showDatePicker(
      cancelText: "Annuler",
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019), //à construire plus tard.
      lastDate: DateTime(2050), //à construire plus tard.
    );

    setState(() => _selectedDate);
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

  Future<void> _createHomework() async {
    await _bD.insertHomework(
      Devoir(
        content: _homeworkContentController.text,
        dueDate: _selectedDate,
        subjectId: _selectedSubject.id,
        priority: _selectedPriority,
        done: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        title: "Nouveau devoir",
        centerTitle: true,
      ),
      body: CreateHomeworkBody(
        selectSubjectFunction: _selectSubject,
        selectedSubject: _selectedSubject,
        homeworkContentController: _homeworkContentController,
        selectDateFunction: _selectDate,
        selectedDate: _selectedDate,
        selectPriorityFunction: _selectPriority,
        selectedPriority: _selectedPriority,
        createHomeworkFunction: _createHomework,
      ),
    );
  }
}
