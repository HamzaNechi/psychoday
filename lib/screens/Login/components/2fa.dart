import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:psychoday/screens/Login/components/verif.dart';
import 'package:psychoday/screens/listDoctor/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/constants.dart';
import 'package:psychoday/screens/Login/components/verif.dart';


class Enable2faScreen extends StatefulWidget {
  @override
  _Enable2faScreenState createState() => _Enable2faScreenState();
}

class _Enable2faScreenState extends State<Enable2faScreen> {
  String? _id;
  String? email;
  late String _secret;
  late String _qrCodeImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUsername();
    _secret = '';
    _qrCodeImageUrl = '';
  }

  Future<void> _loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('_id');
    String? email = prefs.getString('email');
    setState(() {
      _id = id;
      this.email = email;
    });
  }

Future<void> _enable2fa() async {
  try {
    if (_id == null) {
      // Handle error here
      return;
    }
      
    final url = Uri.parse('$BASE_URL/user/enable-2fa');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"_id":_id}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _secret = data['secret'];
        _qrCodeImageUrl = data['qrCodeImageUrl'];
      });

      // Wait for the _loadUsername method to complete before navigating
      await _loadUsername();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage(); // pass the email parameter here
          },
        ),
      );
    } else {
      // Handle error here
    }
  } catch (error) {
    // Handle error here
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enable 2FA')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_qrCodeImageUrl.isNotEmpty) Image.network(_qrCodeImageUrl),
            SizedBox(height: 16),
            if (_secret.isNotEmpty) Text('Secret key: $_secret'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _enable2fa,
              child: Text('Enable 2FA'),
            ),
          ],
        ),
      ),
    );
  }
}
