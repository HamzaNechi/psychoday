import 'dart:convert';

import 'package:http/http.dart' as http;

String apiKey = "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";

class ApiServices {
  static String baseUrl = "https://api.openai.com/v1/completions";

  static Map<String, String> header = {
    'content-type': 'application/json',
    'Authorization': 'Bearer $apiKey'
  };

  static sendMessage(String? message) async {
    var res = await http.post(
      Uri.parse(baseUrl),
      headers: header,
      body: jsonEncode({
        "model": "text-davinci-003",
        "prompt": '$message',
        "max_tokens": 1000,
        "temperature": 0.1,
        //"top_p": 1,
        /// "frequency_penalty": 0.0,
        // "presence_penalty": 0.0,
        // "stop": [" Human:", " AI:"]
      }),
    );

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      var msg = data['choices'][0]['text'];
      print("api response: $msg");
      return msg;
    } else {
      print(res.statusCode);
      print(res.body);
      print("failed to fetch data ");
    }
  }
}
