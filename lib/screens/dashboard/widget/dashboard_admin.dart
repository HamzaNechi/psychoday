import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/reclamation.dart';
import 'package:psychoday/models/user.dart';
import 'package:psychoday/screens/dashboard/components/topscreen_pd.dart';
import 'package:psychoday/screens/profile/profilepage.dart';
import 'package:psychoday/utils/constants.dart';
import 'package:psychoday/utils/responsive.dart';
import 'package:psychoday/utils/style.dart';
import 'package:http/http.dart' as http;


class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileScreenAdmin(), 
      desktop:DesktopScreenAdmin());
  }
}

//**************mobile screen admin dashboard */

class MobileScreenAdmin extends StatefulWidget {
  const MobileScreenAdmin({super.key});

  @override
  State<MobileScreenAdmin> createState() => _MobileScreenAdminState();
}

class _MobileScreenAdminState extends State<MobileScreenAdmin> {
  List<User> users=[
  ];

  Future<List<Reclamation>> fetchData() async {
    //url
    Uri fetchUri = Uri.parse("$BASE_URL/reclamation");

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    List<Reclamation> reclamations=[
    ];

    http.Response response = await http.get(fetchUri, headers: headers);

    if(response.statusCode == 200){
      String responseBody = response.body;
      List<dynamic> data = json.decode(responseBody);
      for (var item in data) {
        
              var reclamation = Reclamation(
               id:  item["_id"],
                email: item['email'],
                message: item['message'],
                date: item['date'] ,
              );
             // print(item);
              reclamations.add(reclamation);
      }
      return reclamations;
    }else{
      
        return reclamations;
    }


    
  }


  @override
  void initState() {
    super.initState();
    //fetchedData = fetchData(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const TopScreenPD(),

          const SizedBox(height: 25,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Style.titleText('Explore your patient', Style.blackColor, 16),
                Style.titleText('see all', Style.primaryLight, 14),
              ],
            ),
          ),



          const SizedBox(height: 12,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              height: 70,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(image:AssetImage(users[index].photo!),fit: BoxFit.cover ),
                          borderRadius: BorderRadius.circular(50)
                        ),
                      ),

                      const SizedBox(width: 20,)
                    ],
                  )
                  ;
                },
              ),
            ),
          ),


          const SizedBox(height: 25,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Style.titleText('Reclamations', Style.blackColor, 16),


                



              ],
            ),
          ),

          //hné
          const SizedBox(height: 10,),

          Expanded(
                  child: FutureBuilder(
                    future: fetchData(),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        List<Reclamation> reclamations=snapshot.data as List<Reclamation>;
                        return ListView.builder(
                        itemCount: reclamations.length,
                        itemBuilder: (context, index) {
                          print(reclamations[index].email);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Container(
                                width: 400,
                                height: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(reclamations[index].email , style:const TextStyle(color: Colors.black ,fontWeight: FontWeight.bold),),
                                    Text(reclamations[index].date , style:const TextStyle(color: Colors.black ,fontWeight: FontWeight.w300),),
                                    SizedBox(height: 8,),
                                    Text(reclamations[index].message , style:const TextStyle(color: Colors.black ,fontWeight: FontWeight.w300),),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                      }else{
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    
                  ),
                )
        ],
      ),


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Style.primaryLight,
        backgroundColor: Style.whiteColor,
        elevation: 0,
        items:  [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home)
          ),

          BottomNavigationBarItem(
            label: 'Bookings',
            icon: Icon(Icons.file_copy)
          ),


          BottomNavigationBarItem(
            label: 'Patients',
            icon: Icon(Icons.group)
          ),

          BottomNavigationBarItem(
            label: 'Profile',
            icon: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RootApp()));
              },
              child: Icon(Icons.person))
          ),
        ]),
    );
  }
}

//**************** end screen doctor dashboard *************** */










//******************** desktop screen doctor********************* */
class DesktopScreenAdmin extends StatefulWidget {
  const DesktopScreenAdmin({super.key});

  @override
  State<DesktopScreenAdmin> createState() => _DesktopScreenAdminState();
}

class _DesktopScreenAdminState extends State<DesktopScreenAdmin> {
  @override
  Widget build(BuildContext context) {
    return const Text("desktop screen admin");
  }
}