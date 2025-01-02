import 'package:bond/features/knowledge_base/models/knowledge_list.dart';

abstract class KnowledgeState {
  const KnowledgeState();

  List<Object?> get props => [];
}

class KnowledgeInitial extends KnowledgeState {}

class KnowledgeLoading extends KnowledgeState {}

class KnowledgeLoaded extends KnowledgeState {
  final KnowledgeList knowledgeList;

  KnowledgeLoaded(this.knowledgeList);

  @override
  List<Object> get props => [knowledgeList];
}

class KnowledgeError extends KnowledgeState {
  final String error;

  KnowledgeError(this.error);

  @override
  List<Object> get props => [error];
}
