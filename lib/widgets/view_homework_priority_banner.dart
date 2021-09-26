import "package:flutter/material.dart";
import '../models/homework.dart';

class ViewHomeworkPriorityBanner extends StatelessWidget {
  final Homework homework;

  ViewHomeworkPriorityBanner({@required this.homework});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Homework.priorityColorMap.values.toList()[homework.priority],
    );
  }
}
