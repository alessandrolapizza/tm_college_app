import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "../models/homework.dart";
import "../models/subject.dart";

class ViewHomeworkDetailsSentence extends StatelessWidget {
  final Homework? homework;

  final bool homePage;

  ViewHomeworkDetailsSentence({
    required this.homework,
    required this.homePage,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 15,
      children: homework!.subject != Subject.noSubject
          ? [
              Text(
                "Contenu du devoir en ",
              ),
              Text(
                homework!.subject!.name!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                homePage ? " à faire pour le " : " qui était à faire pour le ",
              ),
              Text(
                DateFormat("EEEE d MMMM").format(homework!.dueDate!),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: DateTime.now().isAfter(homework!.dueDate!)
                        ? Colors.red
                        : null),
              ),
              Text(" : ")
            ]
          : [
              Text(
                "Contenu du devoir ",
              ),
              Text(
                homePage ? "à faire pour le " : "qui était à faire pour le ",
              ),
              Text(
                DateFormat("EEEE d MMMM").format(homework!.dueDate!),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: DateTime.now().isAfter(homework!.dueDate!)
                        ? Colors.red
                        : null),
              ),
              Text(" : ")
            ],
    );
  }
}
