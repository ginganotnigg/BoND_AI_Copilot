import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/constant.dart';

class AuthApi {

  Future<String> signIn(String email, String password) async {
    final url = Uri.parse(loginUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };
    print(body);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        final String accessToken = jsonResponse['token']['accessToken'];

        print(accessToken);

        return accessToken;
      }
      else return 'failed';
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> signUp(String email, String password, String username) async {
    final url = Uri.parse(signUpUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
      'username': username,
    };
    print(body);
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(Duration(seconds: 10));
      if (response.statusCode == 201) {
        print(response);
        return 'success';
      }
      else {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        if (decodedResponse['details'] is List && decodedResponse['details'].isNotEmpty) {
          String issue = decodedResponse['details'][0]['issue'];
          return issue;
        }
        else return 'Something Wrong, Please Try Again';
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}