import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:timezone/timezone.dart" as tz;
import "package:timezone/data/latest.dart" as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import "package:intl/intl.dart";

class Notifications {
  static bool notificationsPermissionGranted;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializePlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("app.icon");

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (test, test2, test3, test4) {
        return;
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    notificationsPermissionGranted = await flutterLocalNotificationsPlugin
        .initialize(initializationSettings);

    print(notificationsPermissionGranted.toString());
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<List<int>> scheduleNotifications(
      {int homeworkPriority,
      DateTime homeworkDueDate,
      String homeworkSubjectName}) async {
    final priorityNotificationsSettings = [1, 3, 5];
    List<int> notificationsIds = [];
    if (homeworkPriority != 0) {
      for (int i = 1;
          i != priorityNotificationsSettings[homeworkPriority - 1] + 1;
          i++) {
        DateTime scheduleDate = homeworkDueDate.subtract(Duration(days: i));
        int uniqueId = int.parse(
          DateTime.now().millisecondsSinceEpoch.toString().substring(
              DateTime.now().millisecondsSinceEpoch.toString().length - 9),
        );
        await flutterLocalNotificationsPlugin.zonedSchedule(
            uniqueId,
            homeworkSubjectName,
            "Devoir à faire pour le ${DateFormat("EEEE d MMMM").format(homeworkDueDate)}.",
            tz.TZDateTime.local(scheduleDate.year, scheduleDate.month,
                scheduleDate.day, 20, 14, 40),
            const NotificationDetails(
              android: AndroidNotificationDetails('0', 'Devoirs',
                  'Envoie les notifications relatives au temps.'),
            ),
            androidAllowWhileIdle: true,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
        notificationsIds.add(uniqueId);
      }
      print(notificationsIds);
      return notificationsIds;
    } else {
      return null;
    }
  }
}
