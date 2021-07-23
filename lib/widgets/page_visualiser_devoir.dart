import "package:flutter/material.dart";

import "package:intl/intl.dart";
import "../models/matiere.dart";

import "../models/devoir.dart";

class HomeworkDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Devoir homework = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: homework.subject.couleurMatiere,
        child: Icon(Icons.edit),
      ),
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.check))],
        title: Text("Détails du devoir"),
        backgroundColor: homework.subject.couleurMatiere,
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 1.05,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 17,
                  child: Card(
                    color: Devoir.priorityColorMap.values
                        .toList()[homework.priority],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                ),
                Wrap(
                  runSpacing: 15,
                  children: homework.subject != Matiere.noSubject
                      ? [
                          Text(
                            "Contenu du devoir en ",
                          ),
                          Text(
                            homework.subject.nom,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(" à faire pour le "),
                          Text(
                            DateFormat("EEEE d MMMM").format(homework.dueDate),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: DateTime.now().isAfter(homework.dueDate)
                                    ? Colors.red
                                    : null),
                          ),
                          Text(" : ")
                        ]
                      : [
                          Text(
                            "Contenu du devoir ",
                          ),
                          Text("à faire pour le "),
                          Text(
                            DateFormat("EEEE d MMMM").format(homework.dueDate),
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: DateTime.now().isAfter(homework.dueDate)
                                    ? Colors.red
                                    : null),
                          ),
                          Text(" : ")
                        ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 5,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[350],
                      ),
                      borderRadius: BorderRadius.circular(5)),
                  child: ShaderMask(
                    shaderCallback: (Rect rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black,
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black,
                        ],
                        stops: [0.0, 0.02, 0.98, 1.0],
                      ).createShader(rect);
                    },
                    blendMode: BlendMode.dstOut,
                    child: SingleChildScrollView(
                      child: Text(
                        homework.content,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
