import 'dart:ui';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/Notification/notification_home.dart';

import 'package:psychoday/profile/profilepage.dart';
import 'package:psychoday/screens/Login/components/login_otp.dart';
import 'package:psychoday/screens/Welcome/components/login_signup_btn.dart';
import 'package:psychoday/screens/Welcome/welcome_screen.dart';
import 'package:psychoday/screens/listDoctor/pages/home_page.dart';
import 'package:psychoday/screens/welcome.dart';
import 'package:psychoday/therapy/ajout_therapy.dart';
import 'package:psychoday/therapy/detail.dart';
import 'package:psychoday/therapy/list_therapy.dart';
import 'package:psychoday/utils/style.dart';
import './utils/constants.dart';
import 'authentification/auth.dart';



Future<void> main() async {
   AwesomeNotifications().initialize(
    null,
  // set the icon to null if you want to use the default app icon
  [
    NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white)
  ],
  // Channel groups are only visual and are not required
  channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group')
  ],
  debug: true
);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'psychoday',
      theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Style.primaryLight,
              shape: const StadiumBorder(),
              maximumSize: const Size(double.infinity, 56),
              minimumSize: const Size(double.infinity, 56),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Style.clair,
            iconColor: Style.primaryLight,
            prefixIconColor: Style.primaryLight,
            contentPadding: EdgeInsets.symmetric(
            horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
      )),
       home: AnimatedSplashScreen(
        splash: Image.asset("Assets/logo.jpg"),
        duration: 3000,
        splashIconSize:160,
        splashTransition: SplashTransition.fadeTransition, 
        nextScreen:  HomeScreen
        ()),
           routes: {
    
        HomeScreen.routeName: (context) => const HomeScreen(),
        DetailsScreen.routeName: (context) => const DetailsScreen(title: 'Therapy Reserved',),
      },
    );
  }
}
