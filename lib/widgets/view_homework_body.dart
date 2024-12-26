import "package:flutter/material.dart";
import "./view_homework_content.dart";
import "./view_homework_details_sentence.dart";
import "./view_homework_priority_banner.dart";
import "../models/homework.dart";

class ViewHomeworkBody extends StatelessWidget {
  final Homework? homework;

  final bool homePage;

  ViewHomeworkBody({
    required this.homework,
    required this.homePage,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 1.05,
          child: SingleChildScrollView(
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
                ViewHomeworkDetailsSentence(
                  homework: homework,
                  homePage: homePage,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                ),
                ViewHomeworkContent(homework: homework),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
