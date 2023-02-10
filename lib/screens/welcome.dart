import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:psychoday/screens/login.dart';
import 'package:psychoday/utils/style.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final List<List<String>> products=[
    [
      "Assets/images/p1.jpg",
      "Remote detection of bipolar disorder",
      "our chatbot is your doctor"
    ],
    [
      "Assets/images/suivi.jpg",
      "Remote follow-up with your doctor",
      "Create your medical report"
    ],
  ];


  int currentIndex = 0;
   
  void _next(){
    setState(() {
      if(currentIndex < products.length -1){
        currentIndex++;
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const Login()));
      }
    });
  }

  void _prev(){
    setState(() {
      if(currentIndex > 0){
        currentIndex--;
      }else{
        currentIndex=0;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget> [
            GestureDetector(
              onHorizontalDragEnd:(DragEndDetails details){
                if(details.velocity.pixelsPerSecond.dx > 0){
                  _prev();
                }else if (details.velocity.pixelsPerSecond.dx < 0){
                  _next();
                }
              },
              child: Container(
                width: double.infinity,
                height: 650,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(products[currentIndex][0]),
                    fit: BoxFit.cover
                    )
                ),

                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      colors:[
                        Colors.grey[700]!.withOpacity(.9),
                        Colors.grey.withOpacity(.0),
                      ]
                      )
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 90,
                        margin: EdgeInsets.only(bottom: 60),
                        child: Row(
                          children:_buildIndicator(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            Expanded(
              child:Transform.translate(
                offset: const Offset(0, -40),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration:const BoxDecoration(
                    color: Style.whiteColor,
                    borderRadius: BorderRadius.only(topLeft:Radius.circular(30),topRight:Radius.circular(30))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget> [
                      Text(products[currentIndex][1],style: const TextStyle(color: Style.primaryColor,fontSize: 40,fontWeight: FontWeight.bold),),
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children: [
                          Text(products[currentIndex][2],style: const TextStyle(color: Style.secondaryDark,fontSize: 15),),
                        ],
                      )
                    ],
                  ),
                ),
                ),
              )
          ],
        ),
      ),
    ); 
  }



  Widget _indicator(bool isActive){
    return Expanded(
      
      child: Container(
        height: 4,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50) ,
          color: isActive ? Colors.grey[800] : Colors.white,
        ),
      ) ,
      );
  }


  List<Widget> _buildIndicator() {
    List<Widget> indicators=[];
    for(int i = 0 ; i < products.length;i++){
      if(currentIndex == i){
        indicators.add(_indicator(true));
      }else{
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}