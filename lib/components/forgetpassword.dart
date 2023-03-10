import 'package:flutter/material.dart';
import 'package:psychoday/utils/constants.dart';
import 'package:psychoday/utils/style.dart';

class Forget extends StatelessWidget {
  final bool login;
  final Function? press;
  const Forget({
    Key? key,
    this.login = true,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "forget password " : "forget password ? ",
          style: const TextStyle(
              color: Style.primaryLight, fontFamily: 'Mark-Light'),
        ),
        GestureDetector(
          onTap: press as void Function()?,
          child: Text(
            login ? "here" : "here",
            style: const TextStyle(
                color: Style.primary,
                fontFamily: 'Mark-Light',
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
