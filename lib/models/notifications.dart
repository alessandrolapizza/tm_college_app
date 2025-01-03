import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:flutter_native_timezone/flutter_native_timezone.dart";
//import "package:flutter/foundation.dart"; //Pas utilisé ?
import "package:intl/intl.dart";
import "package:notification_permissions/notification_permissions.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:timezone/data/latest.dart" as tz;
import "package:timezone/timezone.dart" as tz;
import "./homework.dart";
import "./my_database.dart";

class Notifications {
  final SharedPreferences sharedPreferences;

  final MyDatabase database;

  Notifications({
    required this.sharedPreferences,
    required this.database,
  });

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String permGranted = "granted";
  static const String permDenied = "denied";
  static const String permUnknown = "unknown";
  static const String permProvisional = "provisional";

  Future<void> initializePlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@drawable/splash");

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? payload) async {
        await notificationFired(payload: payload!);
      },
    );
  }

  Future<void> notificationFired({required String payload}) async {
    await sharedPreferences.setString("notificationOpenedAppPayload", payload);
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> cancelMultipleNotifications(List<int> notificationsList) async {
    for (int i = 0; i != notificationsList.length; i++) {
      await flutterLocalNotificationsPlugin.cancel(
        notificationsList[i],
      );
    }
  }

  Future<List<int>> scheduleNotifications({
    required int homeworkPriority,
    required DateTime? homeworkDueDate,
    required String? homeworkSubjectName,
    List<int>? oldNotifications,
  }) async {
    final List<int> priorityNotificationsSettings = [
      sharedPreferences.getInt("notificationsPriorityNumberWhite") ?? 0,
      sharedPreferences.getInt("notificationsPriorityNumberGreen") ?? 1,
      sharedPreferences.getInt("notificationsPriorityNumberOrange") ?? 3,
      sharedPreferences.getInt("notificationsPriorityNumberRed") ?? 5,
    ];
    List<int> notificationsIds = [];
    if (oldNotifications != null) {
      await cancelMultipleNotifications(oldNotifications);
    }

    for (int i = 1;
        i != priorityNotificationsSettings[homeworkPriority] + 1;
        i++) {
      DateTime scheduleDate = homeworkDueDate!.subtract(Duration(days: i));
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
        scheduleDate.year,
        scheduleDate.month,
        scheduleDate.day,
        int.parse(
          (sharedPreferences.getString("notificationsReminderHour") ?? "17:00")
              .substring(0, 2),
        ),
        int.parse(
          (sharedPreferences.getString("notificationsReminderHour") ?? "17:00")
              .substring(3, 5),
        ),
      ).isAfter(
        DateTime.now(),
      )) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          uniqueId,
          homeworkSubjectName,
          "Devoir à faire pour le ${DateFormat("EEEE d MMMM").format(homeworkDueDate)}.",
          tz.TZDateTime.local(
            scheduleDate.year,
            scheduleDate.month,
            scheduleDate.day,
            int.parse(
              (sharedPreferences.getString("notificationsReminderHour") ??
                      "17:00")
                  .substring(0, 2),
            ),
            int.parse(
              (sharedPreferences.getString("notificationsReminderHour") ??
                      "17:00")
                  .substring(3, 5),
            ),
          ),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              "0",
              "Devoirs",
              "Envoie les notifications relatives au temps.",
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: uniqueId.toString(),
        );
        notificationsIds.add(uniqueId);
      }
    }
    return notificationsIds;
  }

  Future<void> toggleNotifications({
    required toggleState,
    required snapshotData,
  }) async {
    List<Homework> homeworks = [];
    homeworks = await database.homeworks();
    if (toggleState) {
      await sharedPreferences.setBool("notificationsActivated", true);
      homeworks.forEach(
        (homework) async {
          if (!homework.done) {
            database.updateHomework(
              Homework(
                content: homework.content,
                done: homework.done,
                id: homework.id,
                subject: homework.subject,
                dueDate: homework.dueDate,
                priority: homework.priority,
                subjectId: homework.subjectId,
                notificationsIds: await scheduleNotifications(
                  homeworkDueDate: homework.dueDate,
                  homeworkPriority: homework.priority!,
                  homeworkSubjectName: homework.subject!.name,
                  oldNotifications: homework.notificationsIds,
                ),
              ),
            );
          }
        },
      );
      if (snapshotData != Notifications.permGranted) {
        await NotificationPermissions.requestNotificationPermissions(
          iosSettings: const NotificationSettingsIos(
            sound: true,
            badge: true,
            alert: true,
          ),
        );
      }
    } else {
      await sharedPreferences.setBool("notificationsActivated", false);
      homeworks.forEach(
        (homework) async {
          if (!homework.done && homework.notificationsIds != null) {
            await cancelMultipleNotifications(homework.notificationsIds!);
          }
        },
      );
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
          // default: //Je ne pense pas qu'il y a besoin de ça ici + null safety
          //   return null;
        }
      },
    );
  }

  Future<void> changeNotificationsTime({
    required selectedTime,
    required context,
  }) async {
    List<Homework> homeworks;

    await sharedPreferences.setString(
      "notificationsReminderHour",
      selectedTime.format(context),
    );

    homeworks = await database.homeworks();

    homeworks.forEach(
      (homework) async {
        if (!homework.done) {
          database.updateHomework(
            Homework(
              content: homework.content,
              done: homework.done,
              id: homework.id,
              subject: homework.subject,
              dueDate: homework.dueDate,
              priority: homework.priority,
              subjectId: homework.subjectId,
              notificationsIds: await scheduleNotifications(
                homeworkDueDate: homework.dueDate,
                homeworkPriority: homework.priority!,
                homeworkSubjectName: homework.subject!.name,
                oldNotifications: homework.notificationsIds,
              ),
            ),
          );
        }
      },
    );
  }

  rescheduleNotifications() async {
    List<Homework> homeworks;
    homeworks = await database.homeworks();

    homeworks.forEach(
      (homework) async {
        if (!homework.done) {
          if (homework.notificationsIds!.length != 0) {
            await cancelMultipleNotifications(homework.notificationsIds!);
          }
          database.updateHomework(
            Homework(
              content: homework.content,
              done: homework.done,
              id: homework.id,
              subject: homework.subject,
              dueDate: homework.dueDate,
              priority: homework.priority,
              subjectId: homework.subjectId,
              notificationsIds: await scheduleNotifications(
                homeworkDueDate: homework.dueDate,
                homeworkPriority: homework.priority!,
                homeworkSubjectName: homework.subject!.name,
                oldNotifications: homework.notificationsIds,
              ),
            ),
          );
        }
      },
    );
  }
}
