import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychoday/controllers/question_controllers.dart';
import 'package:psychoday/screens/quiz/components/body.dart';


class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
TextButton(
  onPressed: _controller.nextQuestion, child: const Text('Skip'),)     
  ],
      ),
      body:  Body(),
    );
  }
}

