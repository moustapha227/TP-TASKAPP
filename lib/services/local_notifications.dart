import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
//import 'package:timezone/timezone.dart' as tz;
//import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    //FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    //FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final WindowsInitializationSettings initializationSettingsWindows =
        WindowsInitializationSettings(
          appName: 'Flutter Local Notifications Example',
          appUserModelId: 'Com.Dexterous.FlutterLocalNotificationsExample',
          // Search online for GUID generators to make your own
          guid: 'd49b0314-ee7a-4626-bf79-97cdb8a991bb',
        );
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
          macOS: initializationSettingsDarwin,
          linux: initializationSettingsLinux,
          windows: initializationSettingsWindows,
        );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) => null,
    );

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  // simple notification

  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          ' channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  //notification periodique
  static Future showPeriodicNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'your channel id',
          'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );
    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );
    await flutterLocalNotificationsPlugin.periodicallyShowWithDuration(
      1,
      title,
      body,
      Duration(seconds: 60),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> cancelAllNotifications() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showDailynotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Tâches en cours',
      "Tu as tâches en cours aujourd'hui !",
      _nextInstanceOf15h(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel_id',
          'Daily Reminder',
          channelDescription: 'Notification quotidienne à 15h',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  tz.TZDateTime _nextInstanceOf15h() {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      15,
    );
    if (scheduledTime.isBefore(now)) {
      return scheduledTime.add(Duration(days: 1));
    }
    return scheduledTime;
  }
}
