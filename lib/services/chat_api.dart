import 'dart:convert';
import 'package:bond/models/ai_model.dart';
import 'package:bond/global.dart';
import 'package:bond/models/chat_message.dart';
import 'package:bond/models/conversation.dart';
import 'package:http/http.dart' as http;



class ChatApi {
  Future<String> responseFromAI(String message, String modelId) async {
    final url = Uri.parse(aiChatUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $jarvisToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      // 'assistant': {
      //   'id': modelId.toLowerCase().replaceAll(' ', '-'),
      //   'model': 'dify',
      // },
      // 'content': message,
      'content': message,
      'metadata': {
        'conversation': {'messages': []}
      },
      'assistant': {
        'id': getId(modelId),
        'model': 'dify',
        'name': modelId
      }
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['message'];
        // return {
        //   'message': responseData['message'],
        //   'remainingUsage': responseData['remainingUsage'],
        // };
      } else {
        print('Error response status: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception('Failed to get response from AI');
      }
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<List<Conversation>> getConversations(String model) async {
    final String lowercaseModel = model.toLowerCase().replaceAll(' ', '-');
    Map<String, String> params = {
      'assistantId': lowercaseModel,
      'assistantModel': 'dify',
    };
    final url = Uri.parse(allConversationsUrl).replace(queryParameters: params);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $jarvisToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['items'] as List;
        List<Conversation> conversations = data
            .map((conversation) => Conversation.fromJson(conversation))
            .toList();
        return conversations;
      } else {
        throw Exception('Failed to fetch conversations');
      }
    } catch (e) {
      throw Exception('Failed to fetch conversations: $e');
    }
  }

  Future<List<ChatMessage>> getConvMessages(String model, String convId) async {
    final String lowercaseModel = model.toLowerCase().replaceAll(' ', '-');
    Map<String, String> params = {
      'assistantId': lowercaseModel,
      'assistantModel': 'dify',
    };
    final url = Uri.parse('$allConversationsUrl/$convId/messages/')
        .replace(queryParameters: params);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $jarvisToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['items'] as List;
        List<ChatMessage> messages = [];
        for (var item in data) {
          messages.add(ChatMessage.fromJson({'content': item['query']}, true));
          messages
              .add(ChatMessage.fromJson({'content': item['answer']}, false));
        }
        return messages;
      } else {
        print('Error response status: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception('Failed to fetch conversations');
      }
    } catch (e) {
      throw Exception('Failed to fetch conversations: $e');
    }
  }
}
