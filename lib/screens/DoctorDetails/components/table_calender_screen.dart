import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:intl/intl.dart';
import 'package:psychoday/models/schedule.dart';
import 'package:psychoday/screens/Login/login_screen.dart';
import 'package:psychoday/screens/Reservations_consultation/schedule_screen.dart';
import 'package:psychoday/utils/style.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

import '../../../utils/constants.dart';

class TableCalenderDoctor extends StatefulWidget {
  const TableCalenderDoctor({super.key});

  @override
  State<TableCalenderDoctor> createState() => _TableCalenderDoctorState();
}

class _TableCalenderDoctorState extends State<TableCalenderDoctor> {
  DateTime currentDay = DateTime.now();
  late DateTime _date = DateTime.now();
  late String _day = "";

  //String date = DateFormat('EEEE').format(currentDay);
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      currentDay = day;
      _date = day;
      _day = DateFormat('EEEE').format(currentDay);
    });
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<DateTime> _disabledDays = [];

  int? _currentIndex;
  bool _timeSelected = false;

  @override
  void initState() {
    super.initState();
    _disabledDays = List.generate(
      currentDay.day - 1,
      (index) => DateTime(currentDay.year, currentDay.month, currentDay.day),
    );
  }

  //var
  late String _patient = "643be448745ad0cbfd1277d6";
  late String _doctor = "6432c9aa1a2bf140b086fec6";
  late String _time = "";
  late bool _upcoming = true;
  late bool _canceled = false;
//actions
  void sendAppointement() {
    //url
    Uri addUri = Uri.parse("$BASE_URL/appointement/sendAppointement/$_patient");
    String dateOnlyString = DateFormat('yyyy-MM-dd').format(_date);

    // Check if time is empty
    if (_time.isEmpty) {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.warning,
              animType: AnimType.topSlide,
              showCloseIcon: true,
              title: "Warning",
              desc:
                  "Time cannot be empty! \n Please choose the appointement time.")
          .show();
      return;
    }
    //data to send
    Map<String, dynamic> userObject = {
      "patient": _patient,
      "doctor": _doctor,
      "date": dateOnlyString,
      "time": _time,
      "day": _day,
      "upcoming": _upcoming,
      "canceled" : _canceled
    };

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //request
    http
        .post(addUri, headers: headers, body: json.encode(userObject))
        .then((response) async {
      if (response.statusCode == 200) {
        print("Response status: ${response.statusCode}");
        var jsonResponse = response.body;
        print(jsonResponse);
        AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                animType: AnimType.topSlide,
                showCloseIcon: false,
                btnOkOnPress: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => ScheduleScreen()),
                  );
                },
                title: "Success",
                desc: "Appointement made!")
            .show(); // Save jsonResponse in SharedPreferences

      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Server error!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      } else {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.topSlide,
                showCloseIcon: true,
                title: "Alert",
                desc: "You already made an appointement with this date!")
            .show();
      }
    });
  }

  //var
  List<Schedule> doctorschedules = [];

  //actions
  Future<List<Schedule>> getSchedules() async {
    doctorschedules.clear();
//url
    Uri verifyUri =
        Uri.parse("$BASE_URL/schedule/getSchedule/6432c9aa1a2bf140b086fec6");

    //request
    await http
        .get(
      verifyUri,
    )
        .then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        var jsonObject = jsonDecode(response.body);
        //print(jsonObject);
        jsonObject.forEach((schedule) => {
              //print(user),
              doctorschedules.add(Schedule.scheduleWithThreeParameters(
                  dayOfWeek: schedule['dayOfWeek'],
                  startTime: schedule['startTime'],
                  endTime: schedule['endTime']))
            });
        print(doctorschedules);
        return doctorschedules;
      } else {
        return [];
      }
    });
    return doctorschedules;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Style.primaryLight,
        ),
        body: Column(children: [
          _tableCalender(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Center(
              child: Text(
                'Select Appointement Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Schedule>>(
              future: getSchedules(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final schedules = snapshot.data!;
                  print("hey$schedules");
                  // Filter schedules based on selected day
                  final timeSlots = [
                    '8:00 AM',
                    '9:00 AM',
                    '10:00 PM',
                    '11:00 AM',
                    '12:00 AM',
                    '1:00 PM',
                    '2:00 PM',
                    '3:00 PM',
                    '4:00 PM',
                    '5:00 PM'
                  ];

                  final selectedSchedules = schedules
                      .where((schedule) =>
                          schedule.dayOfWeek ==
                              DateFormat('EEEE').format(currentDay) &&
                          timeSlots.contains(schedule.startTime))
                      .toList();

                  print(selectedSchedules); //1

                  return GridView.builder(
                    itemCount: timeSlots.length, // add 1 for start time
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // display start time as first item
                        return InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                              _timeSelected = true;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _currentIndex == index
                                        ? Style.second
                                        : Style.primaryLight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  color: _currentIndex == index
                                      ? Style.second
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  timeSlots[0], // start time
                                  style: TextStyle(
                                    fontFamily: 'Mark-Light',
                                    fontWeight: FontWeight.bold,
                                    color: _currentIndex == index
                                        ? Colors.white
                                        : Style.primaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // display remaining time slots
                        final timeSlot = timeSlots[index];
                        return InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                              _timeSelected = true;
                              _time = timeSlot;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: _currentIndex == index
                                        ? Style.second
                                        : Style.primaryLight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  color: _currentIndex == index
                                      ? Style.second
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  timeSlot,
                                  style: TextStyle(
                                    fontFamily: 'Mark-Light',
                                    fontWeight: FontWeight.bold,
                                    color: _currentIndex == index
                                        ? Colors.white
                                        : Style.primaryLight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  sendAppointement();
                },
                child: const Text(
                  "Book",
                  style: TextStyle(
                      color: Style.whiteColor,
                      fontFamily: 'Mark-Light',
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ),
          ),
        ]));
  }

  Widget _tableCalender() {
    return Column(
      children: [
        Container(
          child: TableCalendar(
            rowHeight: 43,
            headerStyle:
                HeaderStyle(formatButtonVisible: false, titleCentered: true),
            availableGestures: AvailableGestures.all,
            focusedDay: currentDay,
            firstDay: DateTime.utc(2023, 4, 1),
            lastDay: DateTime.utc(2030, 3, 14),
            onDaySelected: _onDaySelected,
            selectedDayPredicate: ((day) => isSameDay(day, currentDay)),
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) => _calendarFormat = format,
            onPageChanged: (focusedDay) {
              currentDay = focusedDay;
            },
            enabledDayPredicate: (day) => day.isAfter(_disabledDays.last),
          ),
        )
      ],
    );
  }
}
