import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../models/knowledge_in_bot.dart';

@immutable
abstract class BotKnowledgeState extends Equatable {
  const BotKnowledgeState();

  @override
  List<Object?> get props => [];
}

class BotKnowledgeInitial extends BotKnowledgeState {} //emit when nothing's changed, keep same list of bots

class BotKnowledgeLoading extends BotKnowledgeState {} //when retrieving

class BotKnowledgeLoaded extends BotKnowledgeState { //after loading complete
  final List<KnowledgeInBot> knowledge;

  const BotKnowledgeLoaded(this.knowledge);

  @override
  List<Object?> get props => [knowledge];
}

class BotKnowledgeModified extends BotKnowledgeState {
  //if something's changed, emit this to make reload
  final String message;

  const BotKnowledgeModified(this.message);

  @override
  List<Object?> get props => [message];
}

class BotKnowledgeError extends BotKnowledgeState {
  final String error;

  const BotKnowledgeError(this.error);

  @override
  List<Object?> get props => [error];
}


//IMPORT STATES--------------------------------------


@immutable
abstract class ImportKnowledgeState extends Equatable {
  const ImportKnowledgeState();

  @override
  List<Object?> get props => [];
}

class KnowledgeInitial extends ImportKnowledgeState {}

class KnowledgeLoading extends ImportKnowledgeState {}

class KnowledgeLoaded extends ImportKnowledgeState {
  final List<KnowledgeInBot> knowledge;

  const KnowledgeLoaded(this.knowledge);

  @override
  List<Object?> get props => [knowledge];
}

class KnowledgeModified extends ImportKnowledgeState {
  final String message;

  const KnowledgeModified(this.message);

  @override
  List<Object?> get props => [message];
}

class ImportKnowledgeError extends ImportKnowledgeState {
  final String error;

  const ImportKnowledgeError(this.error);

  @override
  List<Object?> get props => [error];
}


