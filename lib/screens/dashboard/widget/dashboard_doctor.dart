import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/user.dart';
import 'package:psychoday/screens/articles/articles.dart';
import 'package:psychoday/screens/dashboard/components/topscreen_pd.dart';
import 'package:psychoday/screens/profile/profilepage.dart';
import 'package:psychoday/screens/therapy_pr%C3%A9sentiel/ajout_therapy.dart';
import 'package:psychoday/screens/therapy_pr%C3%A9sentiel/list_therapy.dart';
import 'package:psychoday/utils/responsive.dart';
import 'package:psychoday/utils/style.dart';

class DashboardDoctor extends StatefulWidget {
  const DashboardDoctor({super.key});

  @override
  State<DashboardDoctor> createState() => _DashboardDoctorState();
}

class _DashboardDoctorState extends State<DashboardDoctor> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileScreenDoctor(), 
      desktop:DesktopScreenDoctor());
  }
}

//**************mobile screen doctor dashboard */

class MobileScreenDoctor extends StatefulWidget {
  const MobileScreenDoctor({super.key});

  @override
  State<MobileScreenDoctor> createState() => _MobileScreenDoctorState();
}

class _MobileScreenDoctorState extends State<MobileScreenDoctor> {
  List<User> users=[
  ];

  List<List<String>> services=[
    [
      'Booking',
      'Assets/images/booking.png'
    ],

    [
      'Patients',
      'Assets/images/patient.png'
    ],

    [
      'Therapy groups',
      'Assets/images/groups.png'
    ],

    [
      'Articles',
      'Assets/images/news.png'
    ],
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),

        child: Column(
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
                  scrollDirection: Axis.horizontal,
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
                  Style.titleText('Other services', Style.blackColor, 16),
                ],
              ),
            ),



            //geridview services

            const SizedBox(height: 12,),


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 400,
                child: GridView.builder(
                  gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    String serviceName=services[index][0];
                    String serviceImage=services[index][1];
                    return InkWell(
                      onTap: () {
                        if(serviceName == 'Therapy groups'){
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => AddGroupTherapyScreen()));
                        }else{
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const Articles()));
                        }

                      },
                      child: Card(
                        elevation: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Style.clair,
                            borderRadius: BorderRadius.circular(16)
                          ),
                          width: 110,
                          height: 110,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage(serviceImage)),
                                ),
                              ),
                              
                    
                              const SizedBox(height: 8,),
                    
                              Style.titleText(serviceName, Style.blackColor, 16)
                            ],
                          ),
                        ),
                      ),
                    );
                  }, 
                  
                ),
              ),
            ),
            //end gridview services
          ],
        ),

        


        
      ),


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Style.primaryLight,
        backgroundColor: Style.whiteColor,
        elevation: 0,
        items: [
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
class DesktopScreenDoctor extends StatefulWidget {
  const DesktopScreenDoctor({super.key});

  @override
  State<DesktopScreenDoctor> createState() => _DesktopScreenDoctorState();
}

class _DesktopScreenDoctorState extends State<DesktopScreenDoctor> {
  @override
  Widget build(BuildContext context) {
    return const Text("desktop screen doctor");
  }
}