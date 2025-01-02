import 'dart:convert';
import 'dart:io';
import 'package:bond/config/constant.dart';
import 'package:bond/features/knowledge_unit/models/file_metadata.dart';
import 'package:bond/features/knowledge_unit/models/unit_list.dart';
import 'package:bond/features/knowledge_unit/models/confluence_metadata.dart';
import 'package:bond/features/knowledge_unit/models/drive_metadata.dart';
import 'package:bond/features/knowledge_unit/models/slack_metadata.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UnitApi {
  final headersForFile = {
    'Authorization': 'Bearer $accessKnowledgeToken',
    'Content-Type': 'multipart/form-data'
  };
  final headersForGet = {'Authorization': 'Bearer $accessKnowledgeToken'};
  final headers = {
    'Authorization': 'Bearer $accessKnowledgeToken',
    'Content-Type': 'application/json'
  };

  /// Fetches the list of units for a specific unit base.
  Future<UnitList> getUnitList(String knowledgeId, {int limit = 50}) async {
    final url =
        Uri.parse('$knowledgeUrl/kb-core/v1/knowledge/$knowledgeId/units')
            .replace(queryParameters: {'limit': limit.toString()});
    final response = await http.get(url, headers: headersForGet);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UnitList.fromJson(data);
    } else {
      throw Exception('Failed to fetch units: ${response.body}');
    }
  }

  /// Deletes a unit from the unit base.
  Future<void> deleteUnit(String knowledgeId, String unitId) async {
    final url = Uri.parse(
        '$knowledgeUrl/kb-core/v1/knowledge/$knowledgeId/units/$unitId');
    final response = await http.delete(url, headers: headersForGet);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete unit: ${response.body}');
    }
  }

  /// Updates the status of a unit in the unit base.
  Future<void> updateStatusUnit(String unitId, String status) async {
    final url =
        Uri.parse('$knowledgeUrl/kb-core/v1/knowledge/units/$unitId/status');
    final response = await http.patch(url,
        headers: headers, body: jsonEncode({'status': status}));

    if (response.statusCode != 200) {
      throw Exception('Failed to update unit status: ${response.body}');
    }
  }

  /// Uploads a local file as a unit using multipart form data.
  Future<void> uploadLocalFile(String knowledgeId, File file) async {
    final url =
        Uri.parse('$knowledgeUrl/kb-core/v1/knowledge/$knowledgeId/local-file');
    final request = http.MultipartRequest('POST', url);
    MediaType mediaType =
        MediaType.parse(getMimeType(file.path.split('.').last.toLowerCase()));
    request.headers.addAll(headersForFile);

    // Add the file to the request
    request.files.add(http.MultipartFile(
      'file',
      file.openRead(),
      await file.length(),
      filename: file.path.split('/').last,
      contentType: mediaType,
    ));

    final response = await request.send();
    print(response.stream.bytesToString());
    if (response.statusCode != 200) {
      throw Exception('Failed to upload file');
    }
  }

  /// Uploads a web resource as a unit.
  Future<void> uploadWeb(
      String knowledgeId, String unitName, String webUrl) async {
    final url =
        Uri.parse('$knowledgeUrl/kb-core/v1/knowledge/$knowledgeId/web');
    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({'unitName': unitName, 'webUrl': webUrl}));
    print(response.body);
    if (response.statusCode != 200) {
      throw Exception('Failed to upload web resource: ${response.body}');
    }
  }

  /// Uploads a Slack resource as a unit.
  Future<void> uploadSlack(
      String knowledgeId, String unitName, MetadataSlack data) async {
    final url =
        Uri.parse('$knowledgeUrl/kb-core/v1/knowledge/$knowledgeId/slack');
    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          'unitName': unitName,
          'slackWorkspace': data.slackWorkspace,
          'slackBotToken': data.slackBotToken,
        }));

    if (response.statusCode != 200) {
      throw Exception('Failed to upload Slack resource: ${response.body}');
    }
  }

  /// Uploads a file from a drive as a unit.
  Future<void> uploadDrive(
      String knowledgeId, String unitName, MetadataDrive data) async {
    final url = Uri.parse(
        '$knowledgeUrl/kb-core/v1/knowledge/$knowledgeId/google-drive');
    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          'unitName': unitName,
          'googleDriveFolder': data.driveFileId,
          'accessToken': data.driveAccessToken,
        }));

    if (response.statusCode != 200) {
      throw Exception('Failed to upload Drive resource: ${response.body}');
    }
  }

  /// Uploads a Confluence resource as a unit.
  Future<void> uploadConfluence(
      String knowledgeId, String unitName, MetadataConfluence data) async {
    final url =
        Uri.parse('$knowledgeUrl/kb-core/v1/knowledge/$knowledgeId/confluence');
    final response = await http.post(url,
        headers: headers,
        body: jsonEncode({
          'unitName': unitName,
          'wikiPageUrl': data.wikiPageUrl,
          'confluenceUsername': data.confluenceUsername,
          'confluenceAccessToken': data.confluenceAccessToken,
        }));

    if (response.statusCode != 200) {
      throw Exception('Failed to upload Confluence resource: ${response.body}');
    }
  }

  /// Searches unit in the unit base.
  Future<UnitList> searchUnit(String knowledgeId, String query,
      {int limit = 50}) async {
    final unitList = await getUnitList(knowledgeId, limit: limit);
    // Filter the unit list based on the query
    unitList.units.retainWhere(
        (unit) => unit.name.toLowerCase().contains(query.toLowerCase()));

    return unitList;
  }
}
