import 'package:alarm_app/model/AlarmModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmLocalStorage {
  static const _key = 'alarms';

  Future<List<Alarm>> getAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getStringList(_key) ?? [];
    return alarmsJson.map((json) => alarmFromJson(json)).toList();
  }

  Future<void> saveAlarms(List<Alarm> alarms) async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = alarms.map((alarm) => alarmToJson(alarm)).toList();
    prefs.setStringList(_key, alarmsJson);
  }
}
