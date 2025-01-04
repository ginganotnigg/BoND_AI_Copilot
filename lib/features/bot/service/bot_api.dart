import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/constant.dart';
import '../../../shared/helpers/auth_helper.dart';
import '../../auth/service/auth_api.dart';
import '../models/bot.dart';

class BotApi {
  final AuthApi authApi = AuthApi();

  //BOTS------------------------------------------------------------------------
  Future<Bot> createBot(String name, String description) async {
    String accessToken = await AuthHelper.getAccessTokenKB() ?? '';
    final url = Uri.parse(botUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final Map<String, dynamic> body = {
      'assistantName': name,
      'instructions': description,
      'description': description,
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final String updatedAt = jsonResponse['createdAt'];
        final String id = jsonResponse['id'];
        final String aiId = jsonResponse['openAiAssistantId'];
        final String thread = jsonResponse['openAiThreadIdPlay'];
        //
        return Bot(updatedAt, id, name, aiId, description, thread);
      }
      if (response.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await createBot(name, description);
      }
      return Bot("", "", "", "", "", "");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Bot>> getBots() async {
    String accessToken = await AuthHelper.getAccessTokenKB() ?? '';
    final url = Uri.parse(botUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(
          url,
          headers: headers
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        List<Bot> bots = data.map((dynamic botData) {
          return Bot(
            botData['updatedAt'] ?? "??/??/??",
            botData['id'] ?? "",
            botData['assistantName'] ?? "Unnamed Bot",
            botData['openAiAssistantId'] ?? "",
            botData['description'] ?? "No description",
            botData['openAiThreadIdPlay'] ?? "",
          );
        }).toList();
        return bots;
      }
      if (response.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await getBots();
      }
      throw Exception("Failed to fetch bots with status code: ${response.statusCode}");
    } catch (e) {
      throw Exception("Error fetching bots: $e");
    }
  }

  Future<Bot> updateBot(String botId, String name, String description) async {
    String accessToken = await AuthHelper.getAccessTokenKB() ?? '';
    final url = Uri.parse(_botUrl(botId));
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    final Map<String, dynamic> body = {
      'assistantName': name,
      'instructions': description,
      'description': description,
    };
    try {
      final response = await http.patch(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final String updatedAt = jsonResponse['createdAt'];
        final String id = jsonResponse['id'];
        final String aiId = jsonResponse['openAiAssistantId'];
        final String thread = jsonResponse['openAiThreadIdPlay'];
        //
        return Bot(updatedAt, id, name, aiId, description, thread);
      }
      if (response.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await updateBot(botId, name, description);
      }
      return Bot("", "", "", "", "", "");
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> deleteBot(String botId) async {
    String accessToken = await AuthHelper.getAccessTokenKB() ?? '';
    final url = Uri.parse(_botUrl(botId));
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.delete(
        url,
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await deleteBot(botId);
      }
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }


  //HELPERS---------------------------------------------------------------------
  String _botUrl(String id) {
    return'$botUrl/$id';
  }
  String _botKnowledgeUrl(String botId, String knowledgeId) {
    return'${_botUrl(botId)}/knowledges/$knowledgeId';
  }
}