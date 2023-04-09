import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:psychoday/models/user.dart';
import 'package:psychoday/screens/therapy_pr%C3%A9sentiel/therapy_argument.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_count_down.dart';
import '../../utils/constants.dart';
import '../../utils/style.dart';
import 'chrono.dart';

class DetailsScreen extends StatefulWidget {
  //var
  static const String routeName = "/Details";
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Duration _remainingDuration;
  late Timer _timer;
  String? idUserConnected;
  String? roleUserConnected;

  //var
  bool hasTimerStopped = false;
  bool hasReserved = false;
  //actions
  //verify game

  //buy game
  Future<bool> Reserve(
      String patient_id, String doctor_id, String therapy_id) async {
    //url
    Uri buyUri = Uri.parse("$BASE_URL/reservation/send");

    //headers
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //Object
    Map<String, dynamic> buyObject = {
      "patient": patient_id,
      "doctor": doctor_id,
      "game": therapy_id
    };

    //request
    await http
        .post(buyUri, headers: headers, body: json.encode(buyObject))
        .then((response) {
           hasReserved = true; 
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Information"),
            content: const Text("therapy reserved successfully!"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Dismiss"))
            ],
          );
        },
      );
      if (hasReserved) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Information"),
        content: const Text("You have already reserved this therapy!"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Dismiss"))
        ],
      );
    },
  );
  return;
}
    }).onError((error, stackTrace) => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Information"),
                  content: const Text("Verify : Server error! Try again later"),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Dismiss"))
                  ],
                );
              },
            ));

    return true;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserConnected();
  }

  Future getUserConnected() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? id_user = prefs.getString('_id');
    final String? role_user = prefs.getString('role');
    setState(() {
      idUserConnected=id_user!;
      roleUserConnected=role_user!;
    });
  }
  //build
  @override
  Widget build(BuildContext context) {
    final GameArgument args =
        ModalRoute.of(context)?.settings.arguments as GameArgument;
    final therapyDate = args.therapy.date;
    
//         DateTime therapyDate = args.therapy.date as DateTime;
// DateTime now = DateTime.now();
// Duration remainingTime = therapyDate.difference(now);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            //1
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 300.0,
                    child: Image.network(args.therapy.image),
                    ),
                const SizedBox(
                  height: 20,
                ),
                //2
                Text(
                  args.therapy.titre,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45,
                    color: Style.primary,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(args.therapy.description)
              ],
            ),

            const SizedBox(
              height: 50,
            ),
            //3
            Container(
              
              width: 60.0,
              padding: EdgeInsets.only(top: 3.0, right: 4.0),
              child: CountDownTimer(
                secondsRemaining: 900,
                whenTimeExpires: () {
                  setState(() {
                    hasTimerStopped = true;
                  });
                },
                countDownTimerStyle: TextStyle(
                  color: Style.marron,
                  fontSize: 50.0,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: Text(
                    "number of Participants : ${args.therapy.capacity.toString()}")),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  print('roleUserConnected = $roleUserConnected');
                  print('idUserConnected = $idUserConnected');
                  if(roleUserConnected! == 'patient'){
                    Reserve(idUserConnected!,
                      "63693c1967b2d9380a8d5217", args.therapy.id);
                    setState(() {
                      if (args.therapy.capacity > 0) {
                        args.therapy.setCapacity(args.therapy.capacity - 1);

                      }
                    });
                  }
                  
                },
                icon: const Icon(CupertinoIcons.add),
                label: const Text("Reserve Now"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
