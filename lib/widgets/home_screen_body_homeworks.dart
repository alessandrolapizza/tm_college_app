import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/my_database.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/home_screen_body_homeworks_calendar.dart';
import 'package:tm_college_app/widgets/homeworks_list.dart';

class HomeScreenBodyHomeworks extends StatefulWidget {
  //Pour initState et dispose.
  final MyDatabase database;

  final bool homePage;

  final Notifications notifications;

  final SharedPreferences sharedPreferences;

  HomeScreenBodyHomeworks({
    @required this.database,
    @required this.notifications,
    @required this.sharedPreferences,
    @required this.homePage,
  });

  @override
  State<HomeScreenBodyHomeworks> createState() =>
      _HomeScreenBodyHomeworksState();
}

class _HomeScreenBodyHomeworksState extends State<HomeScreenBodyHomeworks> {
  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations(
  //     [
  //       DeviceOrientation.landscapeRight,
  //       DeviceOrientation.landscapeLeft,
  //       DeviceOrientation.portraitUp,
  //     ],
  //   );
  // }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
      ],
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (MediaQuery.of(context).orientation == Orientation.portrait) {
          return HomeworksList(
              database: widget.database,
              homePage: widget.homePage,
              notifications: widget.notifications,
              sharedPreferences: widget.sharedPreferences);
        } else {
          return HomeScreenBodyHomeworksCalendar(
            notifications: widget.notifications,
            sharedPreferences: widget.sharedPreferences,
            database: widget.database,
          );
        }
      },
    );
  }
}
