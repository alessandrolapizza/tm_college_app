import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:tm_college_app/widgets/app.dart';
import "../models/homework.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "../models/subject.dart";
import "./edit_grade_dialog.dart";
import "./homeworks_list.dart";
import "./home_screen_body_averages.dart";
import "./home_screen_body_subjects.dart";
import "./modular_app_bar.dart";
import "./modular_icon_button.dart";
import "./modular_floating_action_button.dart";

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
  bool _checkNotificationAppLaunchDetails = false;

  void _routePointer(index) async {
    List<Subject> subjects;
    if (index == 0) {
      Navigator.pushNamed(context, "/edit_homework_screen",
          arguments: [null, true]).then((_) => setState(() {}));
    } else if (index == 1) {
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
            await widget.sharedPreferences.setString("homeworkId", homework.id);
            Navigator.popUntil(context, ModalRoute.withName("/"));
            Navigator.pushNamed(
              context,
              "/view_homework_screen",
            ).then((_) => setState(() {}));
            await widget.sharedPreferences
                .setString("notificationOpenedAppPayload", "");
          }
        },
      );
    }

    Future.delayed(
      Duration(milliseconds: 1000),
      () {
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
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (context) {
          DefaultTabController.of(context).addListener(() => setState(() {}));
          return Scaffold(
            appBar: ModularAppBar(
              actions: DefaultTabController.of(context).index == 0
                  ? [
                      ModularIconButton(
                        onPressedFunction: () => Navigator.pushNamed(
                                context, "/done_homeworks_screen")
                            .then((_) => setState(() {})),
                        icon: Icons.checklist_rounded,
                      )
                    ]
                  : null,
              title: DefaultTabController.of(context).index == 0
                  ? Text("Devoirs à faire")
                  : DefaultTabController.of(context).index == 1
                      ? Text("Moyennes")
                      : Text("Matières"),
              centerTitle: false,
            ),
            body: TabBarView(
              children: [
                HomeworksList(
                  sharedPreferences: widget.sharedPreferences,
                  database: widget.database,
                  homePage: true,
                  notifications: widget.notifications,
                ),
                HomeScreenBodyAverages(
                  database: widget.database,
                  sharedPreferences: widget.sharedPreferences,
                  onTapFunctionGradeCard: ({
                    @required int index,
                    @required Subject subject,
                  }) =>
                      Navigator.pushNamed(context, "/view_grade_screen",
                              arguments: [subject, index])
                          .then((_) => setState(() {})),
                ),
                HomeScreenBodySubjects(
                  database: widget.database,
                  onTapSubjectCardFunction: ({@required subject}) =>
                      Navigator.pushNamed(
                    context,
                    "/edit_subject_screen",
                    arguments: [subject],
                  ).then((_) => setState(() {})),
                ),
              ],
            ),
            floatingActionButton: ModularFloatingActionButton(
              onPressedFunction: () =>
                  _routePointer(DefaultTabController.of(context).index),
              icon: Icons.add_rounded,
            ),
            bottomNavigationBar: BottomAppBar(
              child: TabBar(
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                labelColor: Colors.grey[800],
                labelPadding: EdgeInsets.symmetric(vertical: 4),
                unselectedLabelColor: Colors.grey[500],
                indicator: BubbleTabIndicator(
                  indicatorColor:
                      Color(App.defaultColorThemeValue).withOpacity(0.1),
                  indicatorHeight: 47,
                  padding: EdgeInsets.symmetric(horizontal: -7),
                ),
                tabs: [
                  Tab(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.fact_check_rounded),
                          Text("Devoirs"),
                        ],
                      ),
                    ),
                  ),
                  Tab(
                    child: Center(
                      child: FittedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.assessment_rounded),
                            Text("Moyennes"),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Center(
                      child: FittedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.table_rows_rounded),
                            Text("Matières"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
