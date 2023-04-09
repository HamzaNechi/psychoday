 import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:psychoday/models/user.dart';
import 'package:psychoday/utils/style.dart';

import 'package:http/http.dart' as http;

import '../../utils/constants.dart';
import 'components/upcoming_schedule.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  //var
  int _buttonIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: TabBar(
                tabs: [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Past'),
                  Tab(text: 'Cancelled'),
                ],
                onTap: (index) {
                  setState(() {
                    _buttonIndex = index;
                  });
                },
                labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontSize: 16),
                labelColor: Style.primary,
                unselectedLabelColor: Style.blackColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Style.primary,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  UpcomingSchedule(),
                  Container(),
                  Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

