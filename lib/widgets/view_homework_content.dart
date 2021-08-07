import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/fade_gradient.dart';
import "../models/devoir.dart";

class ViewHomeworkContent extends StatelessWidget {
  final Devoir homework;

  ViewHomeworkContent({@required this.homework});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 5,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[350],
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: FadeGradient(
        child: SingleChildScrollView(
          child: Text(
            homework.content,
          ),
        ),
      ),
    );
  }
}
