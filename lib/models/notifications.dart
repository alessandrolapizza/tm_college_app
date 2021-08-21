import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:timezone/timezone.dart" as tz;
import "package:timezone/data/latest.dart" as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import "package:intl/intl.dart";
import "package:flutter/foundation.dart";
import 'package:tm_college_app/models/base_de_donnees.dart';
import 'package:tm_college_app/models/devoir.dart';

class Notifications {
  final SharedPreferences sharedPreferences;

  final BaseDeDonnees database;

  Notifications({
    @required this.sharedPreferences,
    @required this.database,
  });

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String permGranted = "granted";
  static const String permDenied = "denied";
  static const String permUnknown = "unknown";
  static const String permProvisional = "provisional";

  Future<void> initializePlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("icon");

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (test, test2, test3, test4) {
        return;
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<List<int>> scheduleNotifications({
    @required int homeworkPriority,
    @required DateTime homeworkDueDate,
    @required String homeworkSubjectName,
    List<int> oldNotifications,
  }) async {
    final List<int> priorityNotificationsSettings = [1, 3, 5];
    List<int> notificationsIds = [];
    if (oldNotifications != null) {
      for (int i = 0; i != oldNotifications.length; i++) {
        await flutterLocalNotificationsPlugin.cancel(oldNotifications[i]);
      }
    }
    if (homeworkPriority != 0) {
      for (int i = 1;
          i != priorityNotificationsSettings[homeworkPriority - 1] + 1;
          i++) {
        DateTime scheduleDate = homeworkDueDate.subtract(Duration(days: i));
        int uniqueId = await Future.delayed(
          Duration(microseconds: 1),
          () {
            return int.parse(
              DateTime.now().microsecondsSinceEpoch.toString().substring(
                  DateTime.now().microsecondsSinceEpoch.toString().length - 9),
            );
          },
        );
        if (tz.TZDateTime.local(
                scheduleDate.year, scheduleDate.month, scheduleDate.day)
            .isAfter(
          DateTime.now(),
        )) {
          await flutterLocalNotificationsPlugin.zonedSchedule(
              uniqueId,
              homeworkSubjectName,
              "Devoir à faire pour le ${DateFormat("EEEE d MMMM").format(homeworkDueDate)}.",
              tz.TZDateTime.local(
                  scheduleDate.year, scheduleDate.month, scheduleDate.day),
              const NotificationDetails(
                android: AndroidNotificationDetails('0', 'Devoirs',
                    'Envoie les notifications relatives au temps.'),
              ),
              androidAllowWhileIdle: true,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime);
          notificationsIds.add(uniqueId);
        }
      }
      print(notificationsIds);
      return notificationsIds;
    } else {
      return null;
    }
  }

  Future<void> toggleNotifications(toggleState) async {
    List<Devoir> homeworksList = [];
    if (toggleState) {
      NotificationPermissions.requestNotificationPermissions(
        iosSettings: const NotificationSettingsIos(
          sound: true,
          badge: true,
          alert: true,
        ),
      );
      homeworksList = await database.homeworks();
      homeworksList.forEach(
        (homework) async {
          if (!homework.done) {
            await scheduleNotifications(
              homeworkDueDate: homework.dueDate,
              homeworkPriority: homework.priority,
              homeworkSubjectName: homework.subject.nom,
            );
          }
        },
      );
      await sharedPreferences.setBool("notificationsActivated", true);
    } else {
      await sharedPreferences.setBool("notificationsActivated", false);
      flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  Future<String> getCheckNotificationPermStatus() {
    return NotificationPermissions.getNotificationPermissionStatus().then(
      (status) {
        switch (status) {
          case PermissionStatus.denied:
            return permDenied;
          case PermissionStatus.granted:
            return permGranted;
          case PermissionStatus.unknown:
            return permUnknown;
          case PermissionStatus.provisional:
            return permProvisional;
          default:
            return null;
        }
      },
    );
  }
}
