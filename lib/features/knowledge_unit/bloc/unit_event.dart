import 'dart:io';
import 'package:bond/features/knowledge_unit/models/confluence_metadata.dart';
import 'package:bond/features/knowledge_unit/models/drive_metadata.dart';
import 'package:bond/features/knowledge_unit/models/slack_metadata.dart';
import 'package:equatable/equatable.dart';

abstract class UnitEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// Fetch Unit List
class GetUnitListEvent extends UnitEvent {
  final String knowledgeId;

  GetUnitListEvent(this.knowledgeId);

  @override
  List<Object> get props => [knowledgeId];
}

// Delete Unit
class DeleteUnitEvent extends UnitEvent {
  final String knowledgeId;
  final String unitId;

  DeleteUnitEvent(this.knowledgeId, this.unitId);

  @override
  List<Object> get props => [unitId];
}

// Update Unit Status
class UpdateStatusUnitEvent extends UnitEvent {
  final String unitId;
  final String status;

  UpdateStatusUnitEvent(this.unitId, this.status);

  @override
  List<Object> get props => [unitId, status];
}

// Upload Events
class UploadLocalFileEvent extends UnitEvent {
  final String knowledgeId;
  final File file;

  UploadLocalFileEvent(this.knowledgeId, this.file);

  @override
  List<Object> get props => [knowledgeId, file];
}

class UploadWebEvent extends UnitEvent {
  final String knowledgeId;
  final String unitName;
  final String webUrl;

  UploadWebEvent(this.knowledgeId, this.unitName, this.webUrl);

  @override
  List<Object> get props => [unitName, webUrl];
}

class UploadSlackEvent extends UnitEvent {
  final String knowledgeId;
  final String unitName;
  final MetadataSlack metadata;

  UploadSlackEvent(this.knowledgeId, this.unitName, this.metadata);

  @override
  List<Object> get props => [knowledgeId, unitName, metadata];
}

class UploadDriveEvent extends UnitEvent {
  final String knowledgeId;
  final String unitName;
  final MetadataDrive metadata;

  UploadDriveEvent(this.knowledgeId, this.unitName, this.metadata);

  @override
  List<Object> get props => [knowledgeId, unitName, metadata];
}

class UploadConfluenceEvent extends UnitEvent {
  final String knowledgeId;
  final String unitName;
  final MetadataConfluence metadata;

  UploadConfluenceEvent(this.knowledgeId, this.unitName, this.metadata);

  @override
  List<Object> get props => [knowledgeId, unitName, metadata];
}
