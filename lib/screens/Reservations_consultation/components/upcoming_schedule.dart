import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:psychoday/models/appointement.dart';
import 'package:psychoday/utils/style.dart';
import 'package:http/http.dart' as http;

import '../../../models/user.dart';
import '../../../utils/constants.dart';

class UpcomingSchedule extends StatefulWidget {
  const UpcomingSchedule({super.key});

  @override
  State<UpcomingSchedule> createState() => _UpcomingScheduleState();
}

class _UpcomingScheduleState extends State<UpcomingSchedule> {
  //var
  List<Appointement> apps = [];

  //actions
  Future<List<Appointement>> getAppointements() async {
    apps.clear();
    late String _patient = "643be448745ad0cbfd1277d6";

    //url
    Uri verifyUri =
        Uri.parse("$BASE_URL/appointement/getAppointementsPatient/$_patient");

    //request
    try {
      final response = await http.get(verifyUri);
      print('HTTP status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        var jsonObject = jsonDecode(response.body);
        print(jsonObject);

        jsonObject['appointements'].forEach((appointement) => {
              apps.add(Appointement.AppointementWithFourParameter(
                  doctor: User.userWithThreeParameters(
                      fullName: appointement['doctor']['fullName'],
                      speciality: appointement['doctor']['speciality'],
                      assurance: appointement['doctor']['assurance']),
                  date: DateFormat('yyyy-MM-dd').parse(appointement['date']),
                  time: appointement['time'],
                  day: appointement['day'])),
            });
        print(apps);
        return apps;
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('HTTP request failed with error: $e');
      return [];
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Appointement>>(
        future: getAppointements(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Appointement>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<Appointement> pdata = snapshot.data!;

            print(pdata);
            return ListView.builder(
              itemCount: pdata.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About Doctor",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              color: Style.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Style.primary,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Column(children: [
                                ListTile(
                                  title: Text(
                                    "Dr.${pdata[index].doctor!.fullName}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                      "${pdata[index].doctor!.speciality}"),
                                  trailing: CircleAvatar(
                                    radius: 25,
                                    backgroundImage:
                                        AssetImage("Assets/images/avatar.png"),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Divider(
                                    thickness: 1,
                                    height: 20,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Style.primary,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${pdata[index].date}",
                                          style: TextStyle(
                                            color: Style.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.access_time_filled,
                                          color: Style.primary,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${pdata[index].day} at ${pdata[index].time}",
                                          style: TextStyle(
                                            color: Style.blackColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 150,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF4F6FA),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Style.blackColor,
                                          ),
                                        )),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 150,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Style.primary,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text(
                                          "Reschedule",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Style.whiteColor,
                                          ),
                                        )),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                );
              },
            );
          }
          ;
        },
      ),
    );
  }
}
