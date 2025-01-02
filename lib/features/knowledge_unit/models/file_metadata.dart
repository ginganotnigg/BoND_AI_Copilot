import 'package:bond/config/constant.dart';
import 'package:bond/features/knowledge_unit/models/unit_metadata.dart';

Map<String, String> acceptTypeMap = {
  'txt': 'text/plain',
  'pdf': 'application/pdf',
  'docx':
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'pptx':
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
  'html': 'text/html',
  'java': 'text/x-java',
  'c': 'text/x-csrc',
  'cpp': 'text/x-c++src',
  'tex': 'text/x-tex',
};

String getMimeType(String extension) {
  return acceptTypeMap[extension.toLowerCase()] ?? 'text/plain';
}

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
    return localFileImagePath;
  }
}
