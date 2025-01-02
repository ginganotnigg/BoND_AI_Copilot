import 'package:bond/config/constant.dart';
import 'package:bond/features/knowledge_unit/models/unit_metadata.dart';

class MetadataUrl extends UnitMetadata {
  final String webUrl;

  const MetadataUrl({
    required this.webUrl,
  }) : super(type: 'web');

  factory MetadataUrl.fromJson(Map<String, dynamic> json) {
    return MetadataUrl(
      webUrl: json['web_url'] as String,
    );
  }

  @override
  String getType() {
    return "Website";
  }

  @override
  String getIconPath() {
    return webImagePath;
  }
}
