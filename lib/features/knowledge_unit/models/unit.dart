import 'package:bond/features/knowledge_unit/models/unit_metadata.dart';

class Unit {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;
  final DateTime deletedAt;
  final String id;
  final String name;
  final String type;
  final int size;
  final bool status;
  final String userId;
  final String knowledgeId;
  final List<String> openAiFileIds;
  final UnitMetadata metadata;

  Unit({
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedAt,
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.status,
    required this.userId,
    required this.knowledgeId,
    required this.openAiFileIds,
    required this.metadata,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      createdBy: json['createdBy'] ?? "",
      updatedBy: json['updatedBy'] ?? "",
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'])
          : DateTime.now(),
      id: json['id'],
      name: json['name'],
      type: json['type'],
      size: json['size'],
      status: json['status'],
      userId: json['userId'],
      knowledgeId: json['knowledgeId'],
      openAiFileIds: List<String>.from(json['openAiFileIds']),
      metadata: UnitMetadata.fromJson(json['metadata'], json['type']),
    );
  }
}