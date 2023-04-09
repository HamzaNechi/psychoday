import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/therapy_groups.dart';
import 'package:psychoday/screens/Reservations_consultation/schedule_screen.dart';
import 'package:psychoday/screens/dashboard/components/cell_therapy_group.dart';
import 'package:psychoday/screens/dashboard/components/topscreen_pd.dart';
import 'package:psychoday/screens/listDoctor/pages/home_page.dart';
import 'package:psychoday/screens/profile/profilepage.dart';
import 'package:psychoday/screens/therapy_pr%C3%A9sentiel/list_therapy.dart';
import 'package:psychoday/utils/responsive.dart';
import 'package:psychoday/utils/style.dart';

class DashboardPatient extends StatefulWidget {
  const DashboardPatient({super.key});

  @override
  State<DashboardPatient> createState() => _DashboardPatientState();
}

class _DashboardPatientState extends State<DashboardPatient> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: MobileScreenPatient(), 
      desktop:DesktopScreenPatient(),
      );
  }
}


// ignore: slash_for_doc_comments
/********* mobile patient */
class MobileScreenPatient extends StatefulWidget {
  const MobileScreenPatient({super.key});

  @override
  State<MobileScreenPatient> createState() => _MobileScreenPatientState();
}

class _MobileScreenPatientState extends State<MobileScreenPatient> {
  List<TherapyGroup> t_groups=[
   const TherapyGroup(title: 'test', image: 'Assets/images/tg.jpg', organisateur: 'Nechi hamza', date: '12/10/2022'),
    const TherapyGroup(title: 'test', image: 'Assets/images/tg2.jpg', organisateur: 'Rania nedin', date: '12/09/2023'),
     const TherapyGroup(title: 'test', image: 'Assets/images/tg.jpg', organisateur: 'Sawssen gharbi', date: '01/05/2023'),
      const TherapyGroup(title: 'test', image: 'Assets/images/tg2.jpg', organisateur: 'Beyram ayadi', date: '05/02/2023'),
  ];


  List<List<String>> services=[
    [
      'Bookings',
      'Assets/images/reports.png'
    ],

    [
      'Doctors',
      'Assets/images/doctors.png'
    ],

    [
      'Exercises',
      'Assets/images/ex.png'
    ],

    [
      'Articles',
      'Assets/images/news.png'
    ],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children:[
          const TopScreenPD(),

          const SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Style.titleText('Explore therapy groups', Style.blackColor, 16),
                  InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                    },
                    child: Style.titleText('see all', Style.primaryLight, 14)),
                ],
              ),
            ),

           const SizedBox(height: 12,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: t_groups.length,
                  itemBuilder: (context, index) {
                    return CellTherapyGroup(t_group: t_groups[index]);
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
                        switch (serviceName) {
                          case 'Doctors':
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
                            break;
                          case 'Bookings':
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ScheduleScreen()));
                            break;
                          default : print('not therapy');
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

        ] ),
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
            label: 'Repports',
            icon: Icon(Icons.file_copy)
          ),


          BottomNavigationBarItem(
            label: 'Groups',
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

/****************end mobile screen */










// ignore: slash_for_doc_comments
/*********** start desktop screen ******************/

class DesktopScreenPatient extends StatefulWidget {
  const DesktopScreenPatient({super.key});

  @override
  State<DesktopScreenPatient> createState() => _DesktopScreenPatientState();
}

class _DesktopScreenPatientState extends State<DesktopScreenPatient> {
  @override
  Widget build(BuildContext context) {
    return const Text("desktop screen patient");
  }
}
/*********** end desktop screen************* */