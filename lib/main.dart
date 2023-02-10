import 'dart:ui';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/screens/login.dart';
import 'package:psychoday/screens/welcome.dart';

void main() {
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
        primarySwatch: Colors.blue,
      ),
      home:AnimatedSplashScreen(
        splash: Image.asset("Assets/logo.jpg"),
        duration: 3000,
        splashIconSize:160,
        splashTransition: SplashTransition.fadeTransition, 
        nextScreen: const Welcome()),

      routes: {
        Login.routeName: (context) => const Login(),
      },
    );
  }
}
