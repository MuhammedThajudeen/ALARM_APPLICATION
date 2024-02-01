import 'dart:convert';

Alarm alarmFromJson(String jsonString) =>
    Alarm.fromJson(json.decode(jsonString));

String alarmToJson(Alarm alarm) => json.encode(alarm.toJson());

class Alarm {
  final int id;
  final String label;
  final DateTime time;

  Alarm({required this.id, required this.label, required this.time});

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        id: json['id'],
        label: json['label'],
        time: DateTime.parse(json['time']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'time': time.toIso8601String(),
      };
}