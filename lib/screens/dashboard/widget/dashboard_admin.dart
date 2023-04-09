import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:psychoday/models/user.dart';
import 'package:psychoday/screens/dashboard/components/topscreen_pd.dart';
import 'package:psychoday/screens/profile/profilepage.dart';
import 'package:psychoday/utils/responsive.dart';
import 'package:psychoday/utils/style.dart';

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
          ],
        ),

        


        
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