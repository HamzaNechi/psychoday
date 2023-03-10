import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:psychoday/utils/style.dart';
import "package:latlong2/latlong.dart" as latLng;

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Style.primary,
        body: SingleChildScrollView(
          child: DetailBody(),
        ));
  }
}

class DetailBody extends StatelessWidget {
  const DetailBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Style.whiteColor,
                  ),
                ),
              ),
             
            ],
          ),
          const SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(children: [
              const CircleAvatar(
                radius: 35,
                backgroundImage: AssetImage('Assets/images/avatar.png'),
              ),
              const SizedBox(height: 15),
              const Text(
                "Dr Doctor Name",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Mark-Light',
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Therapist",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0EEFA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.call,
                      color: Style.primaryLight,
                      size: 25,
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0EEFA),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.chat_bubble_text_fill,
                      color: Style.primaryLight,
                      size: 25,
                    ),
                  ),
                ],
              )
            ]),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10.0 * 3),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "About Doctor",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Style.second,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book",
                  style: TextStyle(
                    fontSize: 16,
                    color: Style.blackColor,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Assurance Médicale",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Style.second,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Oui",
                  style: TextStyle(
                    fontSize: 16,
                    color: Style.blackColor,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Style.second,
                  ),
                ),
                ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0EEFA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Style.second,
                      size: 30,
                    ),
                  ),
                  title: const Text(
                    "New York, Medical Center",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const DoctorLocation(),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Style.primary,
                    ),
                  ),
                  child: const Text('Book Appointment'),
                  onPressed: () => {},
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorLocation extends StatelessWidget {
  const DoctorLocation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FlutterMap(
          options: MapOptions(
            center: latLng.LatLng(51.5, -0.09),
            zoom: 13.0,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
          ],
        ),
      ),
    );
  }
}
