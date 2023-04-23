import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psychoday/controllers/question_controllers.dart';
import 'package:psychoday/models/Questions.dart';
import 'package:psychoday/screens/quiz/components/option.dart';
import 'package:psychoday/utils/constants.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    required
    this.question,
  }) : super(key: key);

  final Question question;
  @override
  Widget build(BuildContext context) {
      QuestionController _controller = QuestionController();
    return Container(
      margin:   EdgeInsets.symmetric(horizontal: KDefaultPadding),
      padding:  EdgeInsets.all(KDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Text(
            question.question,
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: KBlackColor),
          ),
           SizedBox(height: KDefaultPadding /2 ),
          ...List.generate(
            question.options.length,
            (index) => Option(
              index: index,
              text: question.options[index],
              press: () => _controller.checkAns(question, index),
            ),
          ),
        ],
      ),
    );
  }
}
