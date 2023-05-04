import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../listDoctor/pages/home_page.dart';

class Verify2FA extends StatefulWidget {
  final String email;

  Verify2FA({required this.email});

  @override
  _Verify2FAState createState() => _Verify2FAState();
}

class _Verify2FAState extends State<Verify2FA> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  bool _isLoading = false;
  bool _verificationFailed = false;

  Future<void> _verify2FA(String token) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse('$BASE_URL/user/enable-2fa'),
        body: {'email': widget.email, 'token': token},
      );
      if (response.statusCode == 200) {
        // Authentication successful, redirect to home page
       
         Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
      } else {
        setState(() {
          _verificationFailed = true;
        });
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify 2FA'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tokenController,
                decoration: InputDecoration(
                  labelText: '2FA Token',
                  hintText: 'Enter the 6-digit token',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the 2FA token';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          _verify2FA(_tokenController.text);
                        }
                      },
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Verify 2FA'),
              ),
              if (_verificationFailed)
                Text(
                  '2FA verification failed. Please try again.',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
