import 'package:alarm_app/model/AlarmModel.dart';
import 'package:alarm_app/utils/constants.dart';
import 'package:alarm_app/utils/notification.dart';
import 'package:alarm_app/viewModel/AlarmProvider.dart';
import 'package:alarm_app/viewModel/scheduleAlarm.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AlarmSettingScreen extends StatefulWidget {
  const AlarmSettingScreen({super.key});

  @override
  State<AlarmSettingScreen> createState() => _AlarmSettingScreenState();
}

class _AlarmSettingScreenState extends State<AlarmSettingScreen> {
  TextEditingController labelController = TextEditingController();
  TimeOfDay? time;

  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: mainColor,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
                height: MediaQuery.of(context).size.height * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          getWeatherBackgroundImage(
                              WeatherType != null ? WeatherType! : ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                        child: Text(
                          WeatherType != null ? WeatherType! : "",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            width: 250,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: Text(
                                'Weather today  ${double.parse(degree != null ? degree!.toStringAsFixed(1) : '0')}°C',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 73, 24, 21),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 80),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('h:mm a').format(time != null
                          ? DateTime(DateTime.now().year, DateTime.now().month,
                              DateTime.now().day, time!.hour, time!.minute)
                          : DateTime.now()),
                      style: timetextStyle(Colors.white),
                    ),
                    IconButton(
                        onPressed: () async {
                          time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          print('time.. $time');
                          if (time != null) {
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.add_alarm_outlined,
                          color: Colors.white,
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('d,M,y').format(date != null
                          ? DateTime(date!.year, date!.month, date!.day)
                          : DateTime.now()),
                      style: timetextStyle(Colors.white),
                    ),
                    IconButton(
                        onPressed: () async {
                          date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year, 12, 31));
                          if (date != null) {
                            setState(() {});
                          }
                        },
                        icon: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: customtextfield(labelController)),
              const SizedBox(
                height: 80,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('cancel')),
                  ElevatedButton(
                      onPressed: () {
                        if (time != null) {
                          DateTime timeSaved = DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                              time!.hour,
                              time!.minute);
                          var times = DateTime(
                              date != null ? date!.year : DateTime.now().year,
                              date != null ? date!.month : DateTime.now().month,
                              date != null ? date!.day : DateTime.now().day,
                              time != null ? time!.hour : DateTime.now().hour,
                              time != null
                                  ? time!.minute
                                  : DateTime.now().minute);
                          if (timeSaved.isAfter(DateTime.now())) {
                            Provider.of<AlarmListProvider>(context,
                                    listen: false)
                                .addAlarm(
                              Alarm(
                                id: UniqueKey().hashCode,
                                label: labelController.text,
                                time: DateTime(
                                  date != null
                                      ? date!.year
                                      : DateTime.now().year,
                                  date != null
                                      ? date!.month
                                      : DateTime.now().month,
                                  date != null ? date!.day : DateTime.now().day,
                                  time != null
                                      ? time!.hour
                                      : DateTime.now().hour,
                                  time != null
                                      ? time!.minute
                                      : DateTime.now().minute,
                                ),
                              ),
                            );
                            scheduleAlarms(context);
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Please select a valid time',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        } else {
                          var times = DateTime(
                              date != null ? date!.year : DateTime.now().year,
                              date != null ? date!.month : DateTime.now().month,
                              date != null ? date!.day : DateTime.now().day,
                              time != null ? time!.hour : DateTime.now().hour,
                              time != null
                                  ? time!.minute
                                  : DateTime.now().minute);
                          if (date != null && date!.isAfter(DateTime.now())) {
                            Provider.of<AlarmListProvider>(context,
                                    listen: false)
                                .addAlarm(
                              Alarm(
                                id: UniqueKey().hashCode,
                                label: labelController.text,
                                time: DateTime(
                                  date != null
                                      ? date!.year
                                      : DateTime.now().year,
                                  date != null
                                      ? date!.month
                                      : DateTime.now().month,
                                  date != null ? date!.day : DateTime.now().day,
                                  time != null
                                      ? time!.hour
                                      : DateTime.now().hour,
                                  time != null
                                      ? time!.minute
                                      : DateTime.now().minute,
                                ),
                              ),
                            );
                            scheduleAlarms(context);
                            Navigator.pop(context);
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Please select a valid time',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.black45,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }
                        }
                      },
                      child: const Text('save')),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget customtextfield(TextEditingController controller) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width - 60,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: TextField(
          autocorrect: false,
          autofocus: false,
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          controller: controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(left: 0),
            hintText: 'Add label',
            hintStyle: TextStyle(
              color: Color(0xffa2a2a2),
              fontSize: 16.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          style: GoogleFonts.oxygen(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  String getWeatherBackgroundImage(String weatherType) {
    switch (weatherType) {
      case 'sunny':
        return 'assets/sunny_background.jpeg';
      case 'Rain':
        return 'assets/rainy_background.jpeg';
      case 'Clouds':
        return 'assets/cloudy_background.jpeg';
      case 'Snow':
        return 'assets/snow_bg.jpeg';
      case 'Mist':
        return 'assets/mist_bg.jpeg';
      case 'Haze':
        return 'assets/haze_bg.jpeg';
      default:
        return 'assets/default_bg.jpeg';
    }
  }
}
