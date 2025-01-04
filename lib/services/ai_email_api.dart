import 'dart:convert';

import 'package:bond/global.dart';
import 'package:bond/models/email/email_reply.dart';
import 'package:bond/models/email/email_reply_response.dart';
import 'package:http/http.dart' as http;

class AiEmailApi {
  Future<EmailReplyResponse> responseEmail(EmailReply emailReply) async {
    final url = Uri.parse(aiEmailUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $jarvisToken',
      'Content-Type': 'application/json',
    };

    try {
      final body = jsonEncode(emailReply.toJson());
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return EmailReplyResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to response email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to response email: $e');
    }
  }
}
