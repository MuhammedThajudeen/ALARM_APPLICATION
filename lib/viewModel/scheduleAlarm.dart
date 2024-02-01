import 'package:alarm_app/utils/notification.dart';
import 'package:alarm_app/viewModel/AlarmProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> scheduleAlarms(BuildContext context) async {
  final now = DateTime.now();
  Provider.of<AlarmListProvider>(context, listen: false).loadalarms();
  for (final alarm
      in Provider.of<AlarmListProvider>(context, listen: false).alarms) {
    if (alarm.time.isAfter(now)) {
      final timeUntilAlarm = alarm.time.difference(now);
      await Future.delayed(timeUntilAlarm, () {
        alarmCallback(alarm.label, alarm.time);
      });
    }
  }
}
