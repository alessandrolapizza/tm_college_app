import "package:flutter/material.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/homework.dart';
import 'package:tm_college_app/models/subject.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/home_screen_body_averages.dart';

import 'package:tm_college_app/widgets/home_screen_bottom_app_bar.dart';
import 'package:tm_college_app/widgets/modular_icon_button.dart';
import 'package:tm_college_app/widgets/edit_grade_dialog.dart';
import "./modular_app_bar.dart";
import 'homeworks_list.dart';
import "./modular_floating_action_button.dart";
import 'home_screen_body_subjects.dart';
import '../models/my_database.dart';

class HomeScreen extends StatefulWidget {
  final MyDatabase database;

  final Notifications notifications;

  final SharedPreferences sharedPreferences;

  HomeScreen({
    @required this.database,
    @required this.notifications,
    @required this.sharedPreferences,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _index = 0;

  bool _checkNotificationAppLaunchDetails = false;

  void _changeIndex(index) => setState(() => _index = index);

  String get _title {
    String text;

    if (_index == 0) {
      text = "Devoirs";
    } else if (_index == 1) {
      text = "Moyennes";
    } else {
      text = "Matières";
    }

    return text;
  }

  Widget get _homePageBody {
    Widget body;

    if (_index == 0) {
      body = HomeworksList(
        database: widget.database,
        homePage: true,
        notifications: widget.notifications,
      );
    } else if (_index == 1) {
      body = HomeScreenBodyAverages(
        database: widget.database,
        sharedPreferences: widget.sharedPreferences,
        onTapFunctionGradeCard: ({
          @required int index,
          @required Subject subject,
        }) =>
            Navigator.pushNamed(context, "/view_grade_screen",
                arguments: [subject, index]).then((_) => setState(() {})),
      );
    } else {
      body = HomeScreenBodySubjects(
        database: widget.database,
        onTapSubjectCardFunction: ({@required subject}) => Navigator.pushNamed(
          context,
          "/edit_subject_screen",
          arguments: [subject],
        ).then((_) => setState(() {})),
      );
    }

    return body;
  }

  void _routePointer() async {
    List<Subject> subjects;
    if (_index == 0) {
      Navigator.pushNamed(context, "/edit_homework_screen",
          arguments: [null, true]).then((_) => setState(() {}));
    } else if (_index == 1) {
      subjects = await widget.database.subjects();
      showDialog(
        context: context,
        builder: (_) {
          return EditGradeDialog(
            database: widget.database,
            sharedPreferences: widget.sharedPreferences,
            subjects: subjects,
          );
        },
      ).then((_) => setState(() {}));
    } else {
      Navigator.pushNamed(context, "/edit_subject_screen")
          .then((_) => setState(() {}));
    }
  }

  void checkNotificationOpenedApp() async {
    final String optionalPayload =
        widget.sharedPreferences.getString("notificationOpenedAppPayload");
    String payload;
    if (!_checkNotificationAppLaunchDetails &&
        (optionalPayload == "" || optionalPayload == null)) {
      final NotificationAppLaunchDetails notificationAppLaunchDetails =
          await widget.notifications.flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
      if (notificationAppLaunchDetails.didNotificationLaunchApp) {
        payload = notificationAppLaunchDetails.payload;
        _checkNotificationAppLaunchDetails = true;
      }
    } else {
      payload = optionalPayload;
    }

    if (payload != null && payload != "") {
      List<Homework> homeworks;
      homeworks = await widget.database.homeworks();
      homeworks.forEach(
        (homework) async {
          if (homework.notificationsIds.contains(int.parse(payload))) {
            Navigator.popUntil(context, ModalRoute.withName("/"));
            Navigator.pushNamed(
              context,
              "/view_homework_screen",
              arguments: [
                homework,
                true,
              ],
            ).then((_) => setState(() {}));
            await widget.sharedPreferences
                .setString("notificationOpenedAppPayload", "");
          }
        },
      );
    }

    Future.delayed(
      Duration(milliseconds: 1000),
      () async {
        checkNotificationOpenedApp();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    checkNotificationOpenedApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModularAppBar(
        actions: _index == 0
            ? [
                ModularIconButton(
                  onPressedFunction: () =>
                      Navigator.pushNamed(context, "/done_homeworks_screen")
                          .then((_) => setState(() {})),
                  icon: Icons.checklist_rounded,
                )
              ]
            : null,
        title: Text(_title),
        centerTitle: false,
      ),
      body: _homePageBody,
      floatingActionButton: ModularFloatingActionButton(
        onPressedFunction: _routePointer,
        icon: Icons.add_rounded,
      ),
      bottomNavigationBar: HomePageBottomAppBar(
        changeIndexFunction: _changeIndex,
        indexSelectionne: _index,
      ),
    );
  }
}
