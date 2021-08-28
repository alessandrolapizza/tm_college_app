import "package:flutter/material.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tm_college_app/models/devoir.dart';
import 'package:tm_college_app/models/notifications.dart';
import 'package:tm_college_app/widgets/home_screen_body_grades.dart';

import 'package:tm_college_app/widgets/home_screen_bottom_app_bar.dart';
import 'package:tm_college_app/widgets/modular_icon_button.dart';
import "./modular_app_bar.dart";
import 'homeworks_list.dart';
import "./modular_floating_action_button.dart";
import 'home_screen_body_subjects.dart';
import "../models/base_de_donnees.dart";

class HomeScreen extends StatefulWidget {
  final BaseDeDonnees database;

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
      text = "Notes";
    } else {
      text = "Matières";
    }

    return text;
  }

  Widget get _homePageBody {
    Widget body;

    if (_index == 0) {
      body = HomeworksList(
        db: widget.database,
        homePage: true,
        notifications: widget.notifications,
      );
    } else if (_index == 1) {
      body = HomeScreenBodyGrades();
    } else {
      body = HomeScreenBodySubjects(widget.database);
    }

    return body;
  }

  void _routePointer() {
    if (_index == 0) {
      Navigator.pushNamed(context, "/edit_homework_screen",
          arguments: [null, true]).then((_) => setState(() {}));
    } else if (_index == 1) {
      Navigator.pushNamed(context, "/create_subject_screen")
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
      List<Devoir> homeworks;
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
            );
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
                  icon: Icons.checklist,
                )
              ]
            : null,
        title: Text(_title),
        centerTitle: false,
      ),
      body: _homePageBody,
      floatingActionButton: ModularFloatingActionButton(
        onPressedFunction: _routePointer,
        icon: Icons.add,
      ),
      bottomNavigationBar: HomePageBottomAppBar(
        changerIndex: _changeIndex,
        indexSelectionne: _index,
      ),
    );
  }
}
