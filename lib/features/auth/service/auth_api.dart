import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/constant.dart';
import '../../../shared/helpers/auth_helper.dart';
import '../models/tokens.dart';

class AuthApi {

  Future<Tokens> signIn(String email, String password) async {
    final url = Uri.parse(loginUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'email': email,
      'password': password,
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final String accessToken = jsonResponse['token']['accessToken'];
        final String refreshToken = jsonResponse['token']['refreshToken'];
        await AuthHelper.setAccessToken(accessToken);
        await AuthHelper.setRefreshToken(refreshToken);
        await AuthHelper.setLoggedInStatus(true);
        return Tokens(true, accessToken, refreshToken, 'Logged In Successfully');
      }
      else {
        return Tokens(false, '', '', 'Wrong login information');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Tokens> signUp(String email, String password, String username) async {
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
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        return Tokens(true, '', '', 'Signed Up successfully');
      }
      else {
        Map<String, dynamic> decodedResponse = jsonDecode(response.body);
        if (decodedResponse['details'] is List && decodedResponse['details'].isNotEmpty) {
          String issue = decodedResponse['details'][0]['issue'];
          return Tokens(false, '', '', issue);
        }
        else {
          return Tokens(false, '', '', 'Something wrong happened, please try again');
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signOut() async {
    final url = Uri.parse(signOutUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
      }
      await AuthHelper.clearAll();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> refreshToken(String refreshToken) async {
    final url = Uri.parse(refreshTokenUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'refreshToken': refreshToken
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final String accessToken = jsonResponse['token']['accessToken'];
        await AuthHelper.setAccessToken(accessToken);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}