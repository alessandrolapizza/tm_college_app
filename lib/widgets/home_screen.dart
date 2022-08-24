import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/services.dart';
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import 'package:tm_college_app/widgets/app.dart';
import 'package:tm_college_app/widgets/home_screen_body_homeworks.dart';
import "../models/homework.dart";
import "../models/my_database.dart";
import "../models/notifications.dart";
import "../models/subject.dart";
import "./edit_grade_dialog.dart";
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
  final ScrollController scrollControllerHomeworks = ScrollController();

  bool _checkNotificationAppLaunchDetails = false;

  void _routePointer(index) async {
    List<Subject> subjects;
    if (index == 0) {
      Navigator.pushNamed(context, "/edit_homework_screen",
              arguments: [null, true]).then(
        (_) {
          if (MediaQuery.of(context).orientation == Orientation.portrait &&
              scrollControllerHomeworks.hasClients) {
            double offset = scrollControllerHomeworks.offset;
            scrollControllerHomeworks.animateTo(
              offset + 0.5,
              duration: Duration(milliseconds: 1),
              curve: Curves.bounceIn,
            );
          }
        },
      )
          //     .then((_) {
          //   SystemChrome.setPreferredOrientations([
          //     DeviceOrientation.portraitUp,
          //     DeviceOrientation.landscapeRight,
          //     DeviceOrientation.landscapeLeft,
          //   ]);
          // })
          ; //.then((_) => {setState(() {})});
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
      Navigator.pushNamed(context, "/edit_subject_screen");
      // .then((_) => setState(() {}));
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
            SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp],
            );
            Navigator.pushNamed(
              context,
              "/view_homework_screen",
            ).then(
              (_) {
                if (scrollControllerHomeworks.hasClients) {
                  double offset = scrollControllerHomeworks.offset;
                  scrollControllerHomeworks.animateTo(
                    offset + 0.5,
                    duration: Duration(milliseconds: 1),
                    curve: Curves.bounceIn,
                  );
                }
              },
            );
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
              hideSettingsButton:
                  DefaultTabController.of(context).index == 0 ? true : false,
              actions: DefaultTabController.of(context).index == 0
                  ? [
                      ModularIconButton(
                        onPressedFunction: () {
                          SystemChrome.setPreferredOrientations(
                            [
                              DeviceOrientation.portraitUp,
                            ],
                          );
                          Navigator.pushNamed(context, "/done_homeworks_screen")
                                  .then((_) {
                            if (scrollControllerHomeworks.hasClients) {
                              double offset = scrollControllerHomeworks.offset;
                              scrollControllerHomeworks.animateTo(
                                offset + 0.5,
                                duration: Duration(milliseconds: 1),
                                curve: Curves.bounceIn,
                              );
                            }
                          })
                              //     .then((_) {
                              //   SystemChrome.setPreferredOrientations(
                              //     [
                              //       DeviceOrientation.portraitUp,
                              //       DeviceOrientation.landscapeLeft,
                              //       DeviceOrientation.landscapeRight,
                              //     ],
                              //   );
                              //   //setState(() {});
                              // })
                              ;
                        },
                        icon: Icons.checklist_rounded,
                      ),
                      ModularIconButton(
                        onPressedFunction: () async {
                          if (MediaQuery.of(context).orientation ==
                              Orientation.portrait) {
                            SystemChrome.setPreferredOrientations(
                              [
                                DeviceOrientation.landscapeRight,
                                // DeviceOrientation.landscapeLeft,
                              ],
                            );
                          } else {
                            SystemChrome.setPreferredOrientations(
                              [
                                DeviceOrientation.portraitUp,
                              ],
                            );
                            // await Future.delayed(Duration(
                            //     seconds:
                            //         1)); //...... Je sais pas comment faire autrement pour l'instant.
                            // SystemChrome.setPreferredOrientations(
                            //   [
                            //     DeviceOrientation.landscapeLeft,
                            //     DeviceOrientation.landscapeRight,
                            //     DeviceOrientation.portraitUp,
                            //   ],
                            // );
                          }
                        },
                        icon: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? Icons.calendar_month_rounded
                            : Icons.list_alt_rounded,
                      ),
                      ModularIconButton(
                        onPressedFunction: () {
                          SystemChrome.setPreferredOrientations(
                            [
                              DeviceOrientation.portraitUp,
                            ],
                          );
                          Navigator.pushNamed(context, "/settings_screen")
                                  .then((_) {
                            if (scrollControllerHomeworks.hasClients) {
                              double offset = scrollControllerHomeworks.offset;
                              scrollControllerHomeworks.animateTo(
                                offset + 0.5,
                                duration: Duration(milliseconds: 1),
                                curve: Curves.bounceIn,
                              );
                            }
                          })
                              //     .then((_) {
                              //   SystemChrome.setPreferredOrientations(
                              //     [
                              //       DeviceOrientation.portraitUp,
                              //       DeviceOrientation.landscapeLeft,
                              //       DeviceOrientation.landscapeRight,
                              //     ],
                              //   );
                              //   // setState(() {});
                              // })
                              ;
                        },
                        icon: Icons.settings_rounded,
                      ),
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
                HomeScreenBodyHomeworks(
                  scrollControllerHomeworks: scrollControllerHomeworks,
                  database: widget.database,
                  sharedPreferences: widget.sharedPreferences,
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
                    //.then((_) => {setState(() {})}),
                    ),
                HomeScreenBodySubjects(
                    database: widget.database,
                    onTapSubjectCardFunction: ({@required subject}) =>
                        Navigator.pushNamed(
                          context,
                          "/edit_subject_screen",
                          arguments: [subject],
                        ) //.then((_) => {setState(() {})}),
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
