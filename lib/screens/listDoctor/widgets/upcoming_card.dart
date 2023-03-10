import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:psychoday/utils/style.dart';

class UpcomingCard extends StatelessWidget {
  const UpcomingCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 150,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: Style.primaryLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/doctor_2.jpg',
              width: 45,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Find Your Desired\nDoctor',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily:'Red Ring' ,
                    fontSize: 24,
                    color: Color.fromARGB(255, 248, 237, 237),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
             padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Get your confimation",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Color.fromARGB(179, 254, 251, 251),
                    fontWeight: FontWeight.bold,
                      ),
                ),
              ),
           
                  
                  ],
                ),]
              ),);
            
          
        
      
    
  
}}
