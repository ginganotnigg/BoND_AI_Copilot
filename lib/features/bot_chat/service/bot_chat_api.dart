import 'dart:convert';
import 'package:bond/config/constant.dart';
import 'package:flutter/foundation.dart';
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

  String askBotUrl(String id) {
    return '$botUrl/$id/ask';
  }

  String getConvUrl(String id) {
    return '$threadUrl/$id/messages';
  }

  Future<void> askBot(BotConv conv, Bot bot) async {
    //Ask
    final url = Uri.parse(askBotUrl(bot.id));
    final chats = conv.messages;
    final lastMessage = chats.last.content;

    final Map<String, dynamic> body =
      {
        'message': lastMessage,
        'openAiThreadId': bot.id,
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
        return await askBot(conv, bot);
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<String> createNewThread(Bot bot) async {
    String thread;
    final urlCreate = Uri.parse(threadUrl);
    final urlUpdate = Uri.parse(updateThreadUrl);
    final body = jsonEncode({
      {
        'assistantId': bot.id,
        'firstMessage': ''
      }
    });
    try {
      //create
      Map<String,String> headers = await makeHeaders();
      final response = await http.post(urlCreate, headers: headers, body: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        thread = jsonResponse['openAiThreadIdPlay'];
      } else if (response.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await createNewThread(bot);
      } else {
        throw Exception('Failed to send message');
      }
      //update playground
      final response1 = await http.post(urlUpdate, headers: headers, body: body);
      if (response1.statusCode == 200 || response.statusCode == 201) {
        return thread;
      } else if (response1.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await createNewThread(bot);
      }
      throw Exception('Failed to send message');
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<BotConv> getMessage(Bot bot) async {
    final url = Uri.parse(getConvUrl(bot.id));
    try {
      //create
      Map<String,String> headers = await makeHeaders();
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> jsonList = jsonDecode(response.body);
        List<BotChatMessage> messages = jsonList.map((json) => BotChatMessage.fromJson(json)).toList();
        BotConv conv = BotConv(messages);
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
