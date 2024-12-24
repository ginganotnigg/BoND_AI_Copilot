import 'package:bond/features/knowledge_unit/models/unit_metadata.dart';

class MetadataFile extends UnitMetadata {
  final String name;
  final String mimeType;

  const MetadataFile({
    required this.name,
    required this.mimeType,
  }) : super(type: 'local_file');

  factory MetadataFile.fromJson(Map<String, dynamic> json) {
    return MetadataFile(
      name: json['name'] as String,
      mimeType: json['mimetype'] as String,
    );
  }

  @override
  String getType() {
    return "Local file";
  }

  @override
  String getIconPath() {
    return 'lib/assets/images/resources/file.png';
  }
}
