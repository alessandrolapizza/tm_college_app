import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "../models/homework.dart";
import "./circle_avatar_with_border.dart";

class HomeworkCard extends StatelessWidget {
  final Homework homework;

  final Function onTapFunction;

  final Widget actionButton;

  final SharedPreferences sharedPreferences;

  HomeworkCard({
    @required this.homework,
    @required this.onTapFunction,
    @required this.sharedPreferences,
    this.actionButton,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (onTapFunction != null) {
          await sharedPreferences.setString("homeworkId", homework.id);
          onTapFunction();
        }
      },
      child: Container(
        height: 90,
        width: double.infinity,
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 3,
                  color: Homework.priorityColorMap.values
                      .toList()[homework.priority],
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: CircleAvatarWithBorder(
                    color: homework.subject.color,
                    icon: homework.subject.icon,
                  ),
                ),
              ),
              Expanded(
                flex: 13,
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: Column(
                    children: [
                      Text(
                        homework.subject.name,
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 3),
                        child: Text(
                          homework.content,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  child: actionButton,
                ),
              ),
              SizedBox(width: 5,)
            ],
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          ),
        ),
      ),
    );
  }
}
