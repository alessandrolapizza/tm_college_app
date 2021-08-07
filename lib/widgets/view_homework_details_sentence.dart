import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../models/matiere.dart";
import "../models/devoir.dart";

class ViewHomeworkDetailsSentence extends StatelessWidget {
  final Devoir homework;

  ViewHomeworkDetailsSentence({@required this.homework});

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
    );
  }
}
