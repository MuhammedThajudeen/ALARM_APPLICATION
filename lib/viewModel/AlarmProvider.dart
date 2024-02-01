import 'package:alarm_app/model/AlarmModel.dart';
import 'package:alarm_app/model/Alarmstorage.dart';
import 'package:flutter/material.dart';

class AlarmListProvider extends ChangeNotifier {
  List<Alarm> _alarms = [];
  final AlarmLocalStorage _alarmLocalStorage = AlarmLocalStorage();

  List<Alarm> get alarms => _alarms;

  Future<void> loadalarms() async {
    _alarms = await _alarmLocalStorage.getAlarms();
    notifyListeners();
  }

  void _saveAlarms() => _alarmLocalStorage.saveAlarms(_alarms);

  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
    _saveAlarms();
    notifyListeners();
  }

  void editAlarm(int index, Alarm updatedAlarm) {
    _alarms[index] = updatedAlarm;
    _saveAlarms();
    notifyListeners();
  }

  void deleteAlarm(int index) {
    _alarms.removeAt(index);
    _saveAlarms();
    notifyListeners();
  }
}
