import 'dart:convert';
import 'package:bond/global.dart';
import 'package:bond/models/prompt.dart';
import 'package:http/http.dart' as http;

class PromptApi {
  Future<Prompt> createPrompt(Prompt prompt) async {
    final url = Uri.parse(promptUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $jarvisToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode(prompt.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        return Prompt.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create prompt');
      }
    } catch (e) {
      throw Exception('Failed to create prompt: $e');
    }
  }

  Future<List<Prompt>> getPrompts({
    PromptCategory? category,
    bool? isFavorite,
    bool? isPublic,
    int? limit,
    int? offset,
    String? query,
  }) async {
    final url = Uri.parse(promptUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $jarvisToken',
      'Content-Type': 'application/json',
    };
    final params = {
      if (category != null) 'category': category.toString().split('.').last,
      if (isFavorite != null) 'isFavorite': isFavorite.toString(),
      if (isPublic != null) 'isPublic': isPublic.toString(),
      if (limit != null) 'limit': limit.toString(),
      if (offset != null) 'offset': offset.toString(),
      if (query != null && query.isNotEmpty) 'query': query,
    };
    final uri = url.replace(queryParameters: params);

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> prompts = body['items'];
        return prompts.map((dynamic item) => Prompt.fromJson(item)).toList();
      } else {
        throw Exception('Failed to fetch prompts');
      }
    } catch (e) {
      throw Exception('Failed to fetch prompts: $e');
    }
  }

  Future<Prompt> updatePrompt(String id, Prompt prompt) async {
    final url = Uri.parse('$promptUrl/$id');
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $jarvisToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode(prompt.toJson());

    try {
      final response = await http.patch(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return Prompt.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to update prompt');
      }
    } catch (e) {
      throw Exception('Failed to update prompt: $e');
    }
  }

  Future<void> deletePrompt(String id) async {
    final url = Uri.parse('$promptUrl/$id');
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $jarvisToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to delete prompt');
      }
    } catch (e) {
      throw Exception('Failed to delete prompt: $e');
    }
  }

  Future<void> toggleFavoritePrompt(String id, bool isFavorite) async {
    final url = Uri.parse('$promptUrl/$id/favorite');
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $jarvisToken',
      'Content-Type': 'application/json',
    };

    try {
      final response = isFavorite
          ? await http.post(url, headers: headers)
          : await http.delete(url, headers: headers);
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to toggle favorite prompt');
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite prompt: $e');
    }
  }
}
