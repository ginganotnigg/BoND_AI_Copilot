import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import '../models/bot.dart';

@immutable
abstract class BotState extends Equatable {
  const BotState();

  @override
  List<Object?> get props => [];
}

class BotInitial extends BotState {} //emit when nothing's changed, keep same list of bots

class BotLoading extends BotState {} //when retrieving

class BotLoaded extends BotState { //after loading complete
  final List<Bot> bots;

  const BotLoaded(this.bots);

  @override
  List<Object?> get props => [bots];
}

class BotSearched extends BotState { //after search complete
  final List<Bot> bots;

  const BotSearched(this.bots);

  @override
  List<Object?> get props => [bots];
}

class BotModified extends BotState {
  final String message;

  const BotModified(this.message);

  @override
  List<Object?> get props => [message];
}//if something's changed, emit this to make reload

class BotError extends BotState {
  final String error;

  const BotError(this.error);

  @override
  List<Object?> get props => [error];
}
