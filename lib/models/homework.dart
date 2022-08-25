import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import "package:tm_college_app/models/notifications.dart";
import "package:uuid/uuid.dart";
import "./my_database.dart";
import "./subject.dart";

class Homework {
  final String id;
  final String subjectId;
  final Subject subject;
  final String content;
  final DateTime dueDate;
  final int priority;
  final bool done;
  final List<int> notificationsIds;

  Homework({
    @required this.subjectId,
    @required this.content,
    @required this.dueDate,
    @required this.priority,
    @required this.done,
    this.notificationsIds,
    this.subject,
    id,
  }) : id = id == null ? Uuid().v1() : id;

  Map<String, dynamic> toMapDb() {
    return {
      "id": id,
      "subjectId": subjectId,
      "content": content,
      "dueDate": dueDate.toString(),
      "priority": priority,
      "done": done ? 1 : 0,
      "notificationsIds": notificationsIds.toString(),
    };
  }

  static const Map<String, Color> priorityColorMap = {
    "Indifférente": Colors.white,
    "Normale": Colors.lightGreen,
    "Moyenne": Colors.orange,
    "Urgente": Colors.red,
  };

  static Future<void> homeworkChecker({
    @required Homework homework,
    @required MyDatabase database,
    @required Notifications notifications,
  }) async {
    if (!homework.done && homework.notificationsIds != null) {
      await notifications
          .cancelMultipleNotifications(homework.notificationsIds);
    }
    Homework checkedHomework = Homework(
      done: homework.done ? false : true,
      content: homework.content,
      dueDate: homework.dueDate,
      priority: homework.priority,
      subjectId: homework.subjectId,
      subject: homework.subject,
      id: homework.id,
      notificationsIds: homework.done
          ? await notifications.scheduleNotifications(
              homeworkPriority: homework.priority,
              homeworkDueDate: homework.dueDate,
              homeworkSubjectName: homework.subject.name,
            )
          : [],
    );
    await database.updateHomework(checkedHomework);
  }

  static Future<List<Homework>> outHomeworks({
    @required MyDatabase database,
    @required SharedPreferences sharedPreferences,
    DateTime firstTermBeginingDate,
    DateTime secondTermEndingDate,
  }) async {
    List<Homework> outHomeworks = [];
    List<Homework> homeworks = await database.homeworks();
    homeworks.forEach(
      (homework) async {
        if (homework.dueDate.isBefore(firstTermBeginingDate == null
                ? DateTime.parse(
                    sharedPreferences.getString(
                      "firstTermBeginingDate",
                    ),
                  )
                : firstTermBeginingDate) ||
            homework.dueDate.isAfter(
              secondTermEndingDate == null
                  ? DateTime.parse(
                      sharedPreferences.getString(
                        "secondTermEndingDate",
                      ),
                    )
                  : secondTermEndingDate,
            )) {
          outHomeworks.add(homework);
        }
      },
    );
    return outHomeworks;
  }
}
