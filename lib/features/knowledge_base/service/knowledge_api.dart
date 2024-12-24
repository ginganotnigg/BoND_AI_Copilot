import 'dart:convert';
import 'package:bond/config/constant.dart';
import 'package:bond/features/knowledge_base/models/knowledge_list.dart';
import 'package:http/http.dart' as http;

class KnowledgeApi {
  String? accessKnowledgeToken;
  String? refreshKnowledgeToken;
  final headers = {
    'x-jarvis-guid': jarvisGuid,
    'Authorization': 'Bearer $jarvisToken',
    'Content-Type': 'application/json',
  };

  KnowledgeApi() {
    _initTokens();
  }

  // Initialize tokens
  Future<void> _initTokens() async {
    accessKnowledgeToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImJlZjgxMDA4LTg4MTktNGM5NS1iNzZjLWQwODA3YzU0MTNiNSIsImVtYWlsIjoibmd1eWVuYm9jaGFAZ21haWwuY29tIiwiaWF0IjoxNzM0ODEwMjc4LCJleHAiOjE3MzQ4OTY2Nzh9.1PZVTHp6DpDkcBrvsSBjwxyNF7_TtVJeF-BXJrls4N0';
    refreshKnowledgeToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImJlZjgxMDA4LTg4MTktNGM5NS1iNzZjLWQwODA3YzU0MTNiNSIsImVtYWlsIjoibmd1eWVuYm9jaGFAZ21haWwuY29tIiwiaWF0IjoxNzMzNTYwOTc5LCJleHAiOjE3MzM2NDczNzl9.o2OKhw4pGkrQZXSMTguF6imMgjZ3MpaeWEQvYR9fLHk";
  }

  /// Fetches the list of knowledge from the knowledge base.
  Future<KnowledgeList> getKnowledgeList({int limit = 100}) async {
    final url = Uri.parse('$baseUrl/kb-core/v1/knowledge')
        .replace(queryParameters: {'limit': limit.toString()});
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return KnowledgeList.fromJson(data);
    } else {
      throw Exception('Failed to fetch knowledge: ${response.body}');
    }
  }

  /// Adds new knowledge to the knowledge base.
  Future<void> addKnowledge(String title, String desc) async {
    final url = Uri.parse('$knowledgeUrl/kb-core/v1/knowledge');
    final body = jsonEncode({
      'title': title,
      'description': desc,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to add knowledge: ${response.body}');
    }
  }

  /// Deletes knowledge from the knowledge base.
  Future<void> deleteKnowledge(String id) async {
    final url = Uri.parse('$knowledgeUrl/kb-core/v1/knowledge/$id');
    final response = await http.delete(url, headers: headers);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete knowledge: ${response.body}');
    }
  }

  /// Edits existing knowledge in the knowledge base.
  Future<void> editKnowledge(String id, String title, String desc) async {
    final url = Uri.parse('$knowledgeUrl/kb-core/v1/knowledge/$id');
    final body = jsonEncode({
      'title': title,
      'description': desc,
    });

    final response = await http.patch(url, body: body);

    if (response.statusCode != 200) {
      throw Exception('Failed to edit knowledge: ${response.body}');
    }
  }

  /// Searches knowledge in the knowledge base.
  Future<KnowledgeList> searchKnowledge(String query, {int limit = 100}) async {
    final url = Uri.parse('$knowledgeUrl/kb-core/v1/knowledge')
        .replace(queryParameters: {'limit': limit.toString()});
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      KnowledgeList knowledgeList = KnowledgeList.fromJson(data);

      // Filter the knowledge list based on the query
      knowledgeList.knowledgeList.retainWhere((knowledge) =>
          knowledge.title.toLowerCase().contains(query.toLowerCase()) ||
          knowledge.description.toLowerCase().contains(query.toLowerCase()));

      return knowledgeList;
    } else {
      throw Exception('Failed to search knowledge: ${response.body}');
    }
  }
}
