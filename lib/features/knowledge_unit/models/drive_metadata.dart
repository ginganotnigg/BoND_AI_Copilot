import 'package:bond/config/constant.dart';
import 'package:bond/features/knowledge_unit/models/unit_metadata.dart';

class MetadataDrive extends UnitMetadata {
  final String driveFileId;
  final String driveAccessToken;

  const MetadataDrive({
    required this.driveFileId, 
    required this.driveAccessToken
  }) : super(type: 'drive');

  factory MetadataDrive.fromJson(Map<String, dynamic> json) {
    return MetadataDrive(
      driveFileId: json['drive_file_id'] as String,
      driveAccessToken: json['drive_access_token'] as String,
    );
  }

  @override
  String getType() {
    return "Drive";
  }

  @override
  String getIconPath() {
    return driveImagePath;
  }
}