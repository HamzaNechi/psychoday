import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:psychoday/components/forgetpassword.dart';
import 'package:psychoday/screens/Login/components/2fa.dart';
import 'package:psychoday/screens/listDoctor/pages/home_page.dart';
import 'package:psychoday/utils/style.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../therapy/ajout_therapy.dart';
import '../../../utils/constants.dart';
import '../../Signup/components/forget_password.dart';
import '../../Signup/components/verification_email.dart';
import '../../Signup/signup_screen.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late String _email;
  late String _password;
  final GlobalKey<FormState> _keyForm = GlobalKey<FormState>();
  late String idUser = '';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      // url
      Uri addUri = Uri.parse("$BASE_URL/user/info");

      // headers
      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      };

      // request
      http.get(addUri, headers: headers).then((response) async {
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data != null) {
            setState(() {
              idUser = data['_id'];
            });
            await prefs.setString('_id', idUser);
          }
        } else {
          print("Request failed with status: ${response.statusCode}.");
        }
      });
    }
  }
  //actions
  void signinAction() {
    //url
    Uri addUri = Uri.parse("$BASE_URL/user/login");

    //data to send
    Map<String, dynamic> userObject = {"email": _email, "password": _password};

    //data to send
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    //request
    http
        .post(addUri, headers: headers, body: json.encode(userObject))
        .then((response) async {
      if (response.statusCode == 200) {

         final data = json.decode(response.body);

       if (data != null) {
        final token = data['token'] ?? '';
        final userInfo = data['userInfo'] ?? {};
        final userId = userInfo['_id'] ?? '';
        final fullName = userInfo['fullName'] ?? '';
        final email = userInfo['email'] ?? '';

        // Save token and user ID in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('_id', userId);

       }


         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AddGroupTherapyScreen();
            },
          ),
        );
        print("Response status: ${response.statusCode}");
        var jsonResponse = response.body;
        print(jsonResponse);
        

        //Navigator.pushReplacementNamed(context, BottomNavScreen.routeName);
      } else if (response.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Email or password are incorrect!"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Information"),
              content: const Text("Server error! Try again later"),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Dismiss"))
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _keyForm,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (String? value) {
              _email = value!;
            },
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return "Email can't be empty";
              } else if (!(EmailValidator.validate(value))) {
                return "Unvalid Email !";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              onSaved: (String? value) {
                _password = value!;
              },
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return "Password cant be empty!";
                } else if (value.length < 5) {
                  return "Password must have at least 5 caracteres!";
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
            child: ElevatedButton(
              onPressed: () {
                if (_keyForm.currentState!.validate()) {
                  _keyForm.currentState!.save();
                  signinAction();
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(
                    color: Style.whiteColor,
                    fontFamily: 'Mark-Light',
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),

          ),
          
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ),
              );
            },
          ),
           const SizedBox(width: defaultPadding),
          Forget(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Reset();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}