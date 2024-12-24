import 'package:bond/features/knowledge_unit/models/unit_metadata.dart';

class MetadataConfluence extends UnitMetadata {
  final String wikiPageUrl;
  final String confluenceUsername;
  final String confluenceAccessToken;

  const MetadataConfluence({
    required this.wikiPageUrl,
    required this.confluenceUsername,
    required this.confluenceAccessToken,
  }) : super(type: 'confluence');

  factory MetadataConfluence.fromJson(Map<String, dynamic> json) {
    return MetadataConfluence(
      wikiPageUrl: json['wiki_page_url'],
      confluenceUsername: json['confluence_username'],
      confluenceAccessToken: json['confluence_access_token'],
    );
  }

  @override
  String getType() {
    return "Confluence";
  }

  @override
  String getIconPath() {
    return 'lib/assets/images/resources/confluence.png';
  }
}
