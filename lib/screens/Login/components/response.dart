import 'dart:convert';
import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.message,
    required this.data,
  });
  late final String message;
  late final String? data;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = jsonEncode(json['data']); // Encode data to String
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message;
    _data['data'] = data;
    return _data;
  }
}
