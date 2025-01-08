import 'dart:convert';
import 'package:bond/config/constant.dart';
import 'package:http/http.dart' as http;

import '../../../shared/helpers/auth_helper.dart';
import '../../auth/service/auth_api.dart';
import '../../bot/models/bot.dart';
import '../models/bot_chat_message.dart';
import '../models/bot_conv.dart';

class BotChatApi {
  AuthApi authApi = AuthApi();


  Future<Map<String, String>> makeHeaders() async {
    String token = await AuthHelper.getAccessTokenKB() ?? '';
    return {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  String askBotUrl(String idBot) {
    return '$botUrl/$idBot/ask';
  }

  String getConvUrl(String idThread) {
    return '$threadUrl/$idThread/messages';
  }

  Future<void> askBot(String message, Bot bot) async {
    //Ask
    final url = Uri.parse(askBotUrl(bot.id));

    final Map<String, dynamic> body =
      {
        'message': message,
        'openAiThreadId': bot.thread,
        'additionalInstruction': ''
      };

    try {
      Map<String,String> headers = await makeHeaders();
      final response = await http.post(url, headers: headers, body: jsonEncode(body),);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }
      if (response.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await askBot(message, bot);
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<BotConv> getMessage(Bot bot) async {
    final url = Uri.parse(getConvUrl(bot.thread));
    try {
      //create
      Map<String,String> headers = await makeHeaders();
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<BotChatMessage> messages = jsonList
            .map((json) => BotChatMessage.fromJson(json))
            .toList();
        BotConv conv = BotConv(messages);
        return conv;
      } else if (response.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await getMessage(bot);
      }
      throw Exception(jsonDecode(response.body));
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }
}
