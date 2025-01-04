import 'package:equatable/equatable.dart';

abstract class BotKnowledgeEvent extends Equatable {
  const BotKnowledgeEvent();

  @override
  List<Object> get props => [];
}

class GetKnowledgeInBotsRequested extends BotKnowledgeEvent {
  final String botId;

  const GetKnowledgeInBotsRequested(this.botId);
  @override
  List<Object> get props => [botId];
}

class ImportKnowledgeToBotRequested extends BotKnowledgeEvent {
  final String botId;
  final String knowledgeId;

  const ImportKnowledgeToBotRequested(this.botId, this.knowledgeId);
  @override
  List<Object> get props => [botId, knowledgeId];
}

class RemoveKnowledgeFromBotRequested extends BotKnowledgeEvent {
  final String botId;
  final String knowledgeId;

  const RemoveKnowledgeFromBotRequested(this.botId, this.knowledgeId);
  @override
  List<Object> get props => [botId, knowledgeId];
}

//-------------------------------------


abstract class ImportKnowledgeEvent extends Equatable {
  const ImportKnowledgeEvent();

  @override
  List<Object> get props => [];
}
class GetAllKnowledgeRequested extends ImportKnowledgeEvent {
  final String botId;

  const GetAllKnowledgeRequested(this.botId);
  @override
  List<Object> get props => [botId];
}

class AddKnowledgeToBotRequested extends ImportKnowledgeEvent {
  final String botId;
  final String knowledgeId;

  const AddKnowledgeToBotRequested(this.botId, this.knowledgeId);
  @override
  List<Object> get props => [botId, knowledgeId];
}

class ModifyRequested extends ImportKnowledgeEvent {}