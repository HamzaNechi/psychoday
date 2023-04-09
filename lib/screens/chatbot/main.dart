import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:psychoday/screens/chatbot/speech_screen.dart';
import 'package:psychoday/screens/chatbot/tts.dart';



class ChatBot extends StatelessWidget {
  const ChatBot({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SpeechScreen(),
      debugShowCheckedModeBanner: false,
      title: 'Speech to text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
