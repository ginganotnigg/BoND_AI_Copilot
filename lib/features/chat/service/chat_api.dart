import 'dart:convert';
import 'package:bond/features/chat/models/ai_model.dart';
import 'package:bond/config/constant.dart';
import 'package:bond/features/chat/models/chat_message.dart';
import 'package:bond/features/chat/models/conv_params.dart';
import 'package:bond/features/chat/models/conversation.dart';
import 'package:http/http.dart' as http;

class ChatApi {
  final headers = {
    'x-jarvis-guid': jarvisGuid,
    'Authorization': 'Bearer $jarvisToken',
    'Content-Type': 'application/json',
  };

  Future<String> responseFromAI(ConvParams convParams) async {
    final url = Uri.parse(aiChatUrl);
    final model = convParams.modelName;
    final convId = convParams.conversationId;
    final chats = convParams.messages;
    final lastMessage = chats.last.content;
    Map<String, dynamic> metadata = {};
    if (convId != null && convId.isNotEmpty) {
      metadata = {
        'conversation': {
          'id': convId,
          'messages': null,
        }
      };
    }
    final body = jsonEncode({
      'content': lastMessage,
      'metadata': metadata.isEmpty ? null : metadata,
      'assistant': {'id': getId(model!), 'model': 'dify', 'name': model},
    });
    print('Request body: $body');

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
        print('Error response status: ${response.statusCode}');
        print('Error response body: ${response.body}');
        throw Exception('Failed to fetch conversations');
      }
    } catch (e) {
      throw Exception('Failed to fetch conversations: $e');
    }
  }

  Future<String> getLatestConversations(String model) async {
    final conversations = await getConversations(model);
    return conversations.first.id;
  }

  Future<List<ChatMessage>> getConvMessages(String model, String convId) async {
    final String lowercaseModel = model.toLowerCase().replaceAll(' ', '-');
    Map<String, dynamic> params = {
      //'limit': 100,
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
        List<ChatMessage> messages = data.expand((item) {
          return [
            ChatMessage(
              content: item['query'] as String,
              aiModel: model,
              role: 'user',
              files: (item['files'] as List<dynamic>?)?.cast<String>(),
            ),
            ChatMessage(
              content: item['answer'] as String,
              role: 'model',
              aiModel: model,
            ),
          ];
        }).toList();
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
