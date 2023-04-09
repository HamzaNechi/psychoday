import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:psychoday/screens/therapy_pr%C3%A9sentiel/ajout_therapy.dart';
import 'package:psychoday/screens/therapy_pr%C3%A9sentiel/cell.dart';
import 'package:psychoday/screens/therapy_pr%C3%A9sentiel/therapy_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  //var
  static const String routeName = "/Home";
const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //var
  final List<Therapy> games = [];
  late Future<bool> fetchedData;

Future<bool> fetchData(BuildContext context) async {
  //url
  Uri fetchUri = Uri.parse("$BASE_URL/therapy");

  //data to send
  Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  try {
    //request
    http.Response response = await http.get(fetchUri, headers: headers);
   if (response != null && response.statusCode == 200) {
  print('rabiiiii ye rabiii');
  //Selialization
  String responseBody = response.body;
  if (responseBody != null) {
    List<dynamic> data = json.decode(responseBody);
    print("Fetched data: $data");
   for (var item in data) {
    var therapy = Therapy(
      item['_id'] ?? "",
      item['image'] ?? "",
      item['titre'] ?? "",
      item['date'] ?? "",
      item['address'] ?? "",
      item['description'] ?? "",
      item['capacity'] ?? 0,
    );
    games.add(therapy);
    print("Number of items in data list: ${data.length}");
    print("Deserialized data: $item => $therapy");
  }
  } else {
    print("Response body is null");
  }
}else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Information"),
            content: const Text("Server Error! Try agaim later."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Dismiss"))
            ],
          );
        },
      );
    }
  } catch (error) {
    print("Error fetching data: $error");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Information"),
          content: const Text("An error occurred while fetching data."),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Dismiss"))
          ],
        );
      },
    );
  }

  return true;
}


  //life cycle
  @override
  void initState() {
    super.initState();
    fetchedData = fetchData(context);
  }

  //build
  @override
  Widget build(BuildContext context) {
     double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    String? roleUserConnected;

    Future getUserConnected() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? role_user = prefs.getString('role');
    setState(() {
      roleUserConnected=role_user!;
    });
  }

    @override
  void initState() {
    super.initState();
    getUserConnected();
  }

  
      return Scaffold(
        appBar: AppBar(
          title: const Text('Therapy list'),
        ),
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: height * 0.3,
                  width: width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("Assets/123.png"),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(1.0),
                    ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
                  ),
                ),
                Positioned(
                  bottom: 90,
                  left: 20,
                  child: RichText(
                    text: TextSpan(
                        text: "it's Great",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 20),
                        children: [
                          TextSpan(
                              text: "Day for \nGroup Therapy",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24))
                        ]),
                  )
                )
              ],
            ),
            Transform.translate(
              offset: Offset(0.0, -(height * 0.3 - height * 0.26)),
              child: Container(
                width: width,
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: <Widget>[
                       
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 0),
                          child: TextField(
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 3),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Icon(
                                    Icons.search,
                                    size: 30,
                                  ),
                                ),
                                hintText: "Search your therapy",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                        width: 1.0, color: Colors.transparent))),
                          ),
                        ),
                        Container(
                          height: height * 0.6,
                        child: FutureBuilder(
      future: fetchedData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          // Check that the list is not empty before building cells
          if (games.isNotEmpty) {
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                return MenuItemCard(games[index]);
              },
            );
          } else {
            return Center(child: Text("No therapies found"));
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),
                        )
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text("Therapies"),
//         backgroundColor: Colors.white,
//         titleTextStyle: const TextStyle(
//           color: Style.marron,
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.add_call,
//               color: Style.marron,
//             ),
//             onPressed: () {
//               Navigator.pushNamed(context, HomeScreen.routeName);
//             },
//           )
//         ],
//       ),
//      body: FutureBuilder(
//       future: fetchedData,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }
//           // Check that the list is not empty before building cells
//           if (games.isNotEmpty) {
//             return ListView.builder(
//               itemCount: games.length,
//               itemBuilder: (context, index) {
//                 return MenuItemCard(games[index]);
//               },
//             );
//           } else {
//             return Center(child: Text("No therapies found"));
//           }
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     ),
//   );
// }}