import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../config/constant.dart';
import '../../../shared/helpers/auth_helper.dart';
import '../../auth/service/auth_api.dart';
import '../models/knowledge_in_bot.dart';

class BotKnowledgeApi {
  final AuthApi authApi = AuthApi();

  Future<List<KnowledgeInBot>> getKnowledgeInBot(String id) async {
    String accessToken = await AuthHelper.getAccessTokenKB() ?? '';
    final url = Uri.parse(_botKnowledgeUrl(id,""));
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
        //print(jsonDecode(response.body));
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        List<KnowledgeInBot> list = data.map((dynamic bkData) {
          return KnowledgeInBot(
            bkData['id'] ?? "",
            bkData['knowledgeName'] ?? "Unnamed Knowledge",
            bkData['description'] ?? "No description",
          );
        }).toList();
        return list;
      }
      if (response.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await getKnowledgeInBot(id);
      }
      throw Exception("Failed to fetch knowledge with status code: ${response.statusCode}");
    } catch (e) {
      throw Exception("Error fetching knowledge: $e");
    }
  }
  //
  Future<List<KnowledgeInBot>> getAllKnowledge() async {
    String accessToken = await AuthHelper.getAccessTokenKB() ?? '';
    final url = Uri.parse('$knowledgeUrl/v1/knowledge');
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
        List<KnowledgeInBot> list = data.map((dynamic bkData) {
          return KnowledgeInBot(
            bkData['id'] ?? "",
            bkData['knowledgeName'] ?? "Unnamed Knowledge",
            bkData['description'] ?? "No description",
          );
        }).toList();
        return list;
      }
      if (response.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await getAllKnowledge();
      }
      throw Exception("Failed to fetch knowledge with status code: ${response.statusCode}");
    } catch (e) {
      throw Exception("Error fetching knowledge: $e");
    }
  }

  Future<bool> deleteKnowledgeFromBot(String botId, String knowledgeId) async {
    String accessToken = await AuthHelper.getAccessTokenKB() ?? '';
    final url = Uri.parse(_botKnowledgeUrl(botId, knowledgeId));
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
        return await deleteKnowledgeFromBot(botId, knowledgeId);
      }
      return false;
    } catch (e) {
      throw Exception(e);
    }
  }
  Future<bool> addKnowledgeToBot(String botId, String knowledgeId) async {
    String accessToken = await AuthHelper.getAccessTokenKB() ?? '';
    final url = Uri.parse(_botKnowledgeUrl(botId, knowledgeId));
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      final response = await http.post(
        url,
        headers: headers,
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode == 401) {
        await authApi.refreshTokenKB();
        return await addKnowledgeToBot(botId, knowledgeId);
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
    if (knowledgeId.isEmpty) {
      return'${_botUrl(botId)}/knowledges';
    }
    return'${_botUrl(botId)}/knowledges/$knowledgeId';
  }
}