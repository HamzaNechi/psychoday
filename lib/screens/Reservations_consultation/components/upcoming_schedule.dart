import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
  List<User> doctors = [];

//actions
  Future<List<User>> getDoctors() async {


//url
    Uri verifyUri = Uri.parse("$BASE_URL/user/getAllUsers");

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
        jsonObject['users'].forEach((user) => {
              //print(user),
              doctors.add(User.userWithThreeParameters(
                  fullName: user['fullName'],
                  speciality: user['speciality'],
                  assurance: user['assurance']))
            });
        print(doctors);
        return doctors;
      } else { 
        return [];
      }
    });
    return doctors;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<User>>(
        future: getDoctors(), 
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            List<User> pdata = snapshot.data!;
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
                                    "Dr.${pdata[index].fullName}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text("${pdata[index].speciality}"),
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
                                          "12/01/2023",
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
                                          "10:30 AM",
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
