import 'package:alarm_app/model/WeatherModel.dart';
import 'package:alarm_app/utils/constants.dart';
import 'package:alarm_app/view/homescreen.dart';
import 'package:alarm_app/viewModel/AlarmProvider.dart';
import 'package:alarm_app/viewModel/LocationService.dart';
import 'package:alarm_app/viewModel/WeatherService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var androidInit = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initSettings = InitializationSettings(android: androidInit);
  flutterLocalNotificationsPlugin.initialize(initSettings);
  await requestPermissions();
}

Future<void> requestPermissions() async {
  await Permission.location.request();
  await Permission.notification.request();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WeatherService weatherService =
      WeatherService('5342ed1a3a38eda77c5087656695ec99');
  LocationService locationService = LocationService();
  WeatherClass? wetherData;

  @override
  void initState() {
    super.initState();
    _fetchwetherdata();
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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AlarmListProvider>(
          create: (context) => AlarmListProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
