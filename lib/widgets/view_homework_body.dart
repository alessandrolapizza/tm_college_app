import "package:flutter/material.dart";
import 'package:tm_college_app/widgets/view_homework_content.dart';
import 'package:tm_college_app/widgets/view_homework_details_sentence.dart';
import 'package:tm_college_app/widgets/view_homework_priority_banner.dart';
import "../models/devoir.dart";

class ViewHomeworkBody extends StatelessWidget {
  final Devoir homework;

  ViewHomeworkBody({@required this.homework});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                child: ViewHomeworkPriorityBanner(homework: homework),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 15),
              ),
              ViewHomeworkDetailsSentence(homework: homework),
              Padding(
                padding: EdgeInsets.only(bottom: 15),
              ),
              ViewHomeworkContent(homework: homework),
            ],
          ),
        ),
      ),
    );
  }
}
