import 'dart:convert';
import 'package:bond/config/constant.dart';
import 'package:bond/features/knowledge_base/models/knowledge_list.dart';
import 'package:http/http.dart' as http;

import '../../../shared/helpers/auth_helper.dart';
import '../../auth/service/auth_api.dart';

class KnowledgeApi {
  AuthApi authApi = AuthApi();


  Future<Map<String, String>> makeHeaders() async {
    String token = await AuthHelper.getAccessTokenKB() ?? '';
    return {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// Fetches the list of knowledge from the knowledge base.
  Future<KnowledgeList> getKnowledgeList({int limit = 50}) async {
    final url = Uri.parse('$knowledgeUrl/kb-core/v1/knowledge')
        .replace(queryParameters: {
      'limit': limit.toString(),
      // 'order_field': 'createdAt',
      // 'order': 'DESC'
    });
    final headers = await makeHeaders();
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return KnowledgeList.fromJson(data);
    }if (response.statusCode == 401) {
      await authApi.refreshToken();
      return await getKnowledgeList(limit: limit);
    } else {
      throw Exception('Failed to fetch knowledge: ${response.body}');
    }
  }

  /// Adds new knowledge to the knowledge base.
  Future<void> addKnowledge(String title, String desc) async {
    final url = Uri.parse('$knowledgeUrl/kb-core/v1/knowledge');
    final body = jsonEncode({
      'knowledgeName': title,
      'description': desc,
    });
    final headers = await makeHeaders();
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode != 201) {
      if (response.statusCode == 401) {
        await authApi.refreshToken();
        return await addKnowledge(title, desc);
      }
      print('Failed to add knowledge: ${response.body}');
      throw Exception('Failed to add knowledge: ${response.body}');
    }
  }

  /// Deletes knowledge from the knowledge base.
  Future<void> deleteKnowledge(String id) async {
    final url = Uri.parse('$knowledgeUrl/kb-core/v1/knowledge/$id');
    final headers = await makeHeaders();
    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        await authApi.refreshToken();
        return await deleteKnowledge(id);
      }
      throw Exception('Failed to delete knowledge: ${response.body}');
    }
  }

  /// Edits existing knowledge in the knowledge base.
  Future<void> editKnowledge(String id, String title, String desc) async {
    final url = Uri.parse('$knowledgeUrl/kb-core/v1/knowledge/$id');
    final body = jsonEncode({
      'knowledgeName': title,
      'description': desc,
    });

    final headers = await makeHeaders();
    final response = await http.patch(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        await authApi.refreshToken();
        return await editKnowledge(id, title, desc);
      }
      throw Exception('Failed to edit knowledge: ${response.body}');
    }
  }

  /// Searches knowledge in the knowledge base.
  Future<KnowledgeList> searchKnowledge(String query, {int limit = 50}) async {
    final knowledgeList = await getKnowledgeList(limit: limit);
    // Filter the knowledge list based on the query
    knowledgeList.knowledgeList.retainWhere((knowledge) =>
        knowledge.title.toLowerCase().contains(query.toLowerCase()) ||
        knowledge.description.toLowerCase().contains(query.toLowerCase()));

    return knowledgeList;
  }
}
