import 'dart:convert';
import 'package:bond/config/constant.dart';
import 'package:bond/features/prompt/models/prompt.dart';
import 'package:http/http.dart' as http;

import '../../../shared/helpers/auth_helper.dart';
import '../../auth/service/auth_api.dart';

class PromptApi {
  AuthApi authApi = AuthApi();
  Future<Prompt> createPrompt(Prompt prompt) async {
    String token = await AuthHelper.getAccessToken() ?? '';
    final url = Uri.parse(promptUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode(prompt.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        return Prompt.fromJson(jsonDecode(response.body));
      } if (response.statusCode == 401) {
        await authApi.refreshToken();
        return await createPrompt(prompt);
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
    String token = await AuthHelper.getAccessToken() ?? '';
    final url = Uri.parse(promptUrl);
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $token',
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
      } if (response.statusCode == 401) {
        await authApi.refreshToken();
        return await getPrompts(
            category: category,
            isFavorite: isFavorite,
            isPublic: isPublic,
            limit: limit,
            offset: offset,
            query: query
        );
      } else {
        throw Exception('Failed to fetch prompts');
      }
    } catch (e) {
      throw Exception('Failed to fetch prompts: $e');
    }
  }

  Future<Prompt> updatePrompt(String id, Prompt prompt) async {
    String token = await AuthHelper.getAccessToken() ?? '';
    final url = Uri.parse('$promptUrl/$id');
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode(prompt.toJson());

    try {
      final response = await http.patch(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        return Prompt.fromJson(jsonDecode(response.body));
      } if (response.statusCode == 401) {
        await authApi.refreshToken();
        return await updatePrompt(id, prompt);
      } else {
        throw Exception('Failed to update prompt');
      }
    } catch (e) {
      throw Exception('Failed to update prompt: $e');
    }
  }

  Future<void> deletePrompt(String id) async {
    String token = await AuthHelper.getAccessToken() ?? '';
    final url = Uri.parse('$promptUrl/$id');
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    try {
      final response = await http.delete(url, headers: headers);
      if (response.statusCode != 200) {
        if (response.statusCode == 401) {
          await authApi.refreshToken();
          return await deletePrompt(id);
        }
        throw Exception('Failed to delete prompt');
      }
    } catch (e) {
      throw Exception('Failed to delete prompt: $e');
    }
  }

  Future<void> toggleFavoritePrompt(String id, bool isFavorite) async {
    String token = await AuthHelper.getAccessToken() ?? '';
    final url = Uri.parse('$promptUrl/$id/favorite');
    final headers = {
      'x-jarvis-guid': jarvisGuid,
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final response = isFavorite
          ? await http.post(url, headers: headers)
          : await http.delete(url, headers: headers);
      if (response.statusCode != 200 && response.statusCode != 201) {
        if (response.statusCode == 401) {
          await authApi.refreshToken();
          return await toggleFavoritePrompt(id, isFavorite);
        }
        throw Exception('Failed to toggle favorite prompt');
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite prompt: $e');
    }
  }
}
