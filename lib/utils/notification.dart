import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void alarmCallback(String label, DateTime time) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your_channel_id',
    'Alarm channel',
    importance: Importance.max,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('alarm_sound'),
    enableVibration: true,
    playSound: true,
  );

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    label,
    '${DateFormat('h:mm a, d/M/y ').format(DateTime(time.year, time.month, time.day, time.hour, time.minute)).toString()}',
    platformChannelSpecifics,
  );
}
