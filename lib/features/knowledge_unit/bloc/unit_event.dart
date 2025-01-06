import 'dart:io';
import 'package:bond/features/knowledge_base/models/knowledge.dart';
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
  final Knowledge knowledge;

  GetUnitListEvent(this.knowledge);

  @override
  List<Object> get props => [knowledge];
}

// Delete Unit
class DeleteUnitEvent extends UnitEvent {
  final Knowledge knowledge;
  final String unitId;

  DeleteUnitEvent(this.knowledge, this.unitId);

  @override
  List<Object> get props => [knowledge, unitId];
}

// Update Unit Status
class UpdateStatusUnitEvent extends UnitEvent {
  final Knowledge knowledge;
  final String unitId;
  final bool status;

  UpdateStatusUnitEvent(this.knowledge, this.unitId, this.status);

  @override
  List<Object> get props => [knowledge, unitId, status];
}

// Upload Events
class UploadLocalFileEvent extends UnitEvent {
  final Knowledge knowledge;
  final File file;

  UploadLocalFileEvent(this.knowledge, this.file);

  @override
  List<Object> get props => [file];
}

class UploadWebEvent extends UnitEvent {
  final Knowledge knowledge;
  final String unitName;
  final String webUrl;

  UploadWebEvent(this.knowledge, this.unitName, this.webUrl);

  @override
  List<Object> get props => [knowledge, unitName, webUrl];
}

class UploadSlackEvent extends UnitEvent {
  final Knowledge knowledge;
  final String unitName;
  final MetadataSlack metadata;

  UploadSlackEvent(this.knowledge, this.unitName, this.metadata);

  @override
  List<Object> get props => [knowledge, unitName, metadata];
}

class UploadDriveEvent extends UnitEvent {
  final Knowledge knowledge;
  final String unitName;
  final MetadataDrive metadata;

  UploadDriveEvent(this.knowledge, this.unitName, this.metadata);

  @override
  List<Object> get props => [unitName, metadata];
}

class UploadConfluenceEvent extends UnitEvent {
  final Knowledge knowledge;
  final String unitName;
  final MetadataConfluence metadata;

  UploadConfluenceEvent(this.knowledge, this.unitName, this.metadata);

  @override
  List<Object> get props => [knowledge, unitName, metadata];
}

class UpdateCurrentKnowledgeEvent extends UnitEvent {
  final Knowledge updatedKnowledge;

  UpdateCurrentKnowledgeEvent(this.updatedKnowledge);

  @override
  List<Object> get props => [updatedKnowledge];
}

class SearchUnitEvent extends UnitEvent {
  final Knowledge knowledge;
  final String query;

  SearchUnitEvent(this.knowledge, this.query);

  @override
  List<Object> get props => [query];
}
