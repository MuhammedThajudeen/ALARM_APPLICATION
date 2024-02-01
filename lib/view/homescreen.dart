// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:alarm_app/model/AlarmModel.dart';
import 'package:alarm_app/model/Alarmstorage.dart';
import 'package:alarm_app/model/WeatherModel.dart';
import 'package:alarm_app/view/AlarmEditScreen.dart';
import 'package:alarm_app/viewModel/LocationService.dart';
import 'package:alarm_app/viewModel/WeatherService.dart';
import 'package:alarm_app/utils/constants.dart';
import 'package:alarm_app/view/AlarmSettingScreen.dart';
import 'package:alarm_app/viewModel/AlarmProvider.dart';
import 'package:alarm_app/viewModel/scheduleAlarm.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherService weatherService =
      WeatherService('5342ed1a3a38eda77c5087656695ec99');
  LocationService locationService = LocationService();
  WeatherClass? wetherData;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AlarmListProvider>(context, listen: false).loadalarms();
    scheduleAlarms(context);

    _timer = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    scheduleAlarms(context);
    return Scaffold(
      body: SafeArea(
          child: Container(
        height: MediaQuery.of(context).size.height,
        color: mainColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Alarm',
                      style: buttonFontstyle,
                    ),
                    IconButton(
                        onPressed: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlarmSettingScreen()));
                          _fetchwetherdata();
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              Expanded(child: Consumer<AlarmListProvider>(
                builder: (context, alarmList, child) {
                  print('alarmlist ${alarmList.alarms.toList()}');
                  return ListView.builder(
                    itemCount: alarmList.alarms.length,
                    itemBuilder: (context, index) {
                      final alarm = alarmList.alarms[index];
                      return InkWell(
                        onTap: () {
                          _fetchwetherdata();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AlarmEditScreen(
                                        time: alarm.time,
                                        index: index,
                                        controller: TextEditingController(
                                            text: alarm.label),
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: alarm.time.isBefore(DateTime.now())
                                    ? Colors.red
                                    : Colors.green,
                                width: 2),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              alarm.label,
                              style: timetextStyle(Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              DateFormat('h:mm a, d/M/y ').format(alarm.time),
                              style: timetextStyle(Colors.white),
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Provider.of<AlarmListProvider>(context,
                                        listen: false)
                                    .deleteAlarm(index);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ))
            ],
          ),
        ),
      )),
    );
  }

  _fetchwetherdata() async {
    try {
      Position position = await locationService.getLocation();

      final weather = await weatherService.getWeather(
        position.latitude,
        position.longitude,
      );

      wetherData = WeatherClass.fromJson(weather);
      WeatherType = wetherData?.weather?[0].main ?? '';
      WeatherDescription = wetherData?.weather?[0].description ?? '';
      degree = wetherData!.main!.temp! - 273.15;

      print('Weather Data: $weather');
    } catch (e) {
      print('Error: $e');
    }
  }
}
