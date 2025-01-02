import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/constant.dart';
import '../../../shared/helpers/auth_helper.dart';
import '../models/tokens.dart';
import '../models/user.dart';

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
        //
        User user = await getUser(accessToken);
        await AuthHelper.setName(user.name);
        await AuthHelper.setEmail(user.email);
        //
        await signInKB();
        //
        return Tokens(true, accessToken, refreshToken, 'Logged In Successfully');
      }
      else {
        return Tokens(false, '', '', 'Wrong login information');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signInKB() async {
    String token = await AuthHelper.getAccessToken() ?? '';
    final url = Uri.parse(loginKBUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
    };
    final Map<String, dynamic> body = {
      'token': token,
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
        await AuthHelper.setAccessTokenKB(accessToken);
        await AuthHelper.setRefreshTokenKB(refreshToken);
        return;
      }
      if (response.statusCode == 422 || response.statusCode == 498) {
        await refreshToken();
        await signInKB();
        return;
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
    String accessToken = await AuthHelper.getAccessToken() ?? '';
    final url = Uri.parse(signOutUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(
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

  Future<void> refreshToken() async {
    String refreshToken = await AuthHelper.getRefreshToken() ?? '';
    final url = Uri.parse('$refreshTokenUrl?refreshToken=$refreshToken');
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
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final String accessToken = jsonResponse['token']['accessToken'];
        await AuthHelper.setAccessToken(accessToken);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> refreshTokenKB() async {
    String refreshTokenKB = await AuthHelper.getRefreshTokenKB() ?? '';
    final url = Uri.parse('$refreshTokenKBUrl?refreshToken=$refreshTokenKB');
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
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final String accessToken = jsonResponse['token']['accessToken'];
        await AuthHelper.setAccessTokenKB(accessToken);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<User> getUser(String accessToken) async {
    final url = Uri.parse(getUserUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final String name = jsonResponse['username'];
        final String email = jsonResponse['email'];
        return User(name, email);
      }
      if (response.statusCode == 401) {
        refreshToken();
        User user = await getUser(accessToken);
        return user;
      }
      return User('Unnamed User','???@???');
    } catch (e) {
      throw Exception(e);
    }
  }
}