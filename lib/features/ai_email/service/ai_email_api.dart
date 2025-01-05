import 'dart:convert';

import 'package:bond/config/constant.dart';
import 'package:bond/features/ai_email/models/email_reply.dart';
import 'package:bond/features/ai_email/models/email_reply_response.dart';
import 'package:http/http.dart' as http;

import '../../../shared/helpers/auth_helper.dart';
import '../../auth/service/auth_api.dart';

class AiEmailApi {
  final AuthApi authApi = AuthApi();

  Future<EmailReplyResponse> responseEmail(EmailReply emailReply) async {
    String accessToken = await AuthHelper.getAccessToken() ?? '';
    final url = Uri.parse(aiEmailUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };

    try {
      final body = jsonEncode(emailReply.toJson());
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return EmailReplyResponse.fromJson(responseData);
      }
      if (response.statusCode == 401) {
        await authApi.refreshToken();
        return await responseEmail(emailReply);
      }
      else {
        throw Exception('Failed to response email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to response email: $e');
    }
  }
}
