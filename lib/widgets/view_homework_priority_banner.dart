import "package:flutter/material.dart";
import "../models/devoir.dart";

class ViewHomeworkPriorityBanner extends StatelessWidget {
  final Devoir homework;

  ViewHomeworkPriorityBanner({@required this.homework});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Devoir.priorityColorMap.values.toList()[homework.priority],
    );
  }
}
