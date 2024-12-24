import 'package:bond/features/knowledge_unit/models/confluence_metadata.dart';
import 'package:bond/features/knowledge_unit/models/file_metadata.dart';
import 'package:bond/features/knowledge_unit/models/slack_metadata.dart';
import 'package:bond/features/knowledge_unit/models/url_metadata.dart';

abstract class UnitMetadata {
  final String type;

  const UnitMetadata({required this.type});

  factory UnitMetadata.fromJson(Map<String, dynamic> json, String type) {
    switch (type) {
      case 'web':
        return MetadataUrl.fromJson(json);
      case 'local_file':
        return MetadataFile.fromJson(json);
      case 'slack':
        return MetadataSlack.fromJson(json);
      case 'confluence':
        return MetadataConfluence.fromJson(json);
      default:
        throw Exception('Unknown metadata type: $type');
    }
  }
  String getType();
  String getIconPath();
}
