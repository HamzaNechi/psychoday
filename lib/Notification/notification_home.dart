import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class   Not extends StatefulWidget {
   Not({super.key, required this.title});

  final String title;


  @override
  State<Not> createState() => _NotState();
}

class _NotState extends State<Not> {

  @override
  void initState() {

    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
         AwesomeNotifications().requestPermissionToSendNotifications();
      }
    }); 
      
    super.initState();
  }
  triggerNotification(){
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
       channelKey: 'basic_channel',
       title: 'Simple Notification',
       body: 'Simple Buttom',
       ));
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: triggerNotification,
          
          child:  Text('Trigger Notification'),
          )
      )
    );
   
  }
}