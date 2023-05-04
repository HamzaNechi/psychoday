import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:psychoday/Suivie/AddReport.dart';
import 'package:psychoday/utils/style.dart';

import '../utils/constants.dart';
import 'ItemView.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:http/http.dart' as http;

import 'dateCard.dart';





class AddMood extends StatefulWidget {
  @override
  _AddMoodState createState() => _AddMoodState();
}

class _AddMoodState extends State<AddMood> {
  late final moodController = TextEditingController();
  late final dateController = TextEditingController();

  final items = [
    ItemMood(
      title: 'Happy',
      image: Image.asset("Assets/happyy.png",width: 70,height: 70,),
      imgColor: Colors.orange, id: '',
    ),
    ItemMood(
      title: 'Sad',
      image:  Image.asset("Assets/sadd.png",width: 70,height: 70,),
      imgColor: Colors.green, id: '',
    ),
    ItemMood(
      title: 'Angry',
      image:  Image.asset("Assets/angryy.png",width: 70,height: 70,),
      imgColor: Colors.black.withOpacity(0.8), id: '',
    ),
    ItemMood(
      title: 'Calm',
      image:  Image.asset("Assets/calmm.png",width: 70,height: 70,),
      imgColor: Colors.orange, id: '',
    ),
    ItemMood(
      title: 'Manic',
      image:  Image.asset("Assets/manicc.png",width: 70,height: 70,),
      imgColor: Colors.orange, id: '',
    ),
  ];

  final spacing = 10.0;
  final numberOfRows = 3;
  
void addMoodReport(String mood) async {
  
    Uri addUri = Uri.parse('$BASE_URL/report/addMood'); // replace with your API endpoint URL
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'date': DateTime.now().toString(), // use the current date and time
    'mood': mood,
    'user': '63693c1967b2d9380a8d5217' // replace with the user's ID or username
  });

  final response = await http.post(addUri, headers: headers, body: body);

  if (response.statusCode == 200) {
    // handle success response
    final responseData = json.decode(response.body);
    print(responseData['message']);
    print(responseData['newReport']);
     showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Success!"),
        content: Text("Your mood has been added."),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddReport()),
              );
            },
          ),
        ],
      );
    },
  );
  } else {
    // handle error response
    final responseData = json.decode(response.body);
    print(responseData['message']);
    print(responseData['verifReport']);
  }
}
  @override
  void dispose() {
    moodController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final columns = List.generate(
      1,
      (index) => const Flexible(
        child: SizedBox.shrink(),
      ),
    ).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            GridView.count(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: items.map((item) {
                return InkWell(
              onTap: () {
          addMoodReport(item.title); 
      },
                  child:  ItemView(item: item),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildHeader() {
    return Container(
      height: 280,
      width: double.infinity,
      color:Style.second,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sawssen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'How are you feeling today?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}