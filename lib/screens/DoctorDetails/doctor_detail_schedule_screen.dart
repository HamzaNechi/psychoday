import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:psychoday/screens/dashboard/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';
import '../../utils/style.dart';

class DoctorDetailsScheduleScreen extends StatefulWidget {
  const DoctorDetailsScheduleScreen({super.key});

  @override
  State<DoctorDetailsScheduleScreen> createState() =>
      _DoctorDetailsScheduleScreenState();
}

class _DoctorDetailsScheduleScreenState
    extends State<DoctorDetailsScheduleScreen> {
  bool _showTextField = false;
  late TimeOfDay _selectedTime = TimeOfDay.now();
  late TimeOfDay _selectedTime1 = TimeOfDay.now();


  String roleUser='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserConnected();
  }

  Future getUserConnected() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? role = prefs.getString('role');
    setState(() {
      roleUser=role!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text(
                          "Your working hours",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Style.primaryLight,
                              fontFamily: 'Red Ring',
                              fontSize: 25),
                        ),
                      ),
                      Column(children: [
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Monday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Add Time"),
                                      content: Container(
                                        width: double.maxFinite,
                                        height: 150,
                                        child: StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    
                                                    DropdownMenuItem(
                                                      child: Row(
                                                        children: [
                                                          
                                                          SizedBox(width: 10),
                                                          Text(
                                                            _selectedTime1 !=
                                                                    null
                                                                ? _selectedTime1
                                                                    .format(
                                                                        context)
                                                                : 'Pick Time',
                                                          ),
                                                        ],
                                                      ),
                                                      value: 'time_picker1',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'other1',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_picker1') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime1) {
                                                        if (selectedTime1 !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime1 =
                                                                selectedTime1;
                                                          });
                                                        }
                                                      });
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Starting time or closed",
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                DropdownButtonFormField<String>(
                                                  items: [
                                                    DropdownMenuItem(
                                                      child: Text(
                                                        _selectedTime != null
                                                            ? _selectedTime
                                                                .format(context)
                                                            : 'Pick Time',
                                                      ),
                                                      value: 'time_picker',
                                                    ),
                                                    DropdownMenuItem(
                                                      child: Text('Closed'),
                                                      value: 'other',
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    if (value ==
                                                        'time_picker') {
                                                      showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            TimeOfDay.now(),
                                                      ).then((selectedTime) {
                                                        if (selectedTime !=
                                                            null) {
                                                          setState(() {
                                                            _selectedTime =
                                                                selectedTime;
                                                          });
                                                        }
                                                      });
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        "Ending time or closed",
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                      actions: [
                                        FloatingActionButton(
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        FloatingActionButton(
                                          child: Text("Add"),
                                          onPressed: () {
                                            // perform action to add task
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Tuesday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Wednesday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Thursday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Friday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Saturday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                          ),
                        ),
                        const SizedBox(height: defaultPadding),
                        ListTile(
                          onTap: () {},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          tileColor: Style.secondLight,
                          leading: Icon(Icons.calendar_month_sharp,
                              color: Style.primary),
                          title: Text('Sunday',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: "Mark-Light")),
                          trailing: Container(
                            height: 35,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Style.primary,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: IconButton(
                              color: Style.whiteColor,
                              iconSize: 18,
                              icon: Icon(Icons.add),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ]),
                    ]),
                  ),
                  const SizedBox(height: defaultPadding),
                  Hero(
                    tag: "doctor_detail_schedule_btn",
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Dashboard(role: roleUser)));
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(
                            color: Style.whiteColor,
                            fontFamily: 'Mark-Light',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
