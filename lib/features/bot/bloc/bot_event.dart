import 'package:equatable/equatable.dart';

import '../models/bot.dart';

abstract class BotEvent extends Equatable {
  const BotEvent();

  @override
  List<Object> get props => [];
}

class CreateBotRequested extends BotEvent {
  final String name;
  final String description;

  const CreateBotRequested(this.name, this.description);

  @override
  List<Object> get props => [name, description];
}

class GetBotsRequested extends BotEvent {
  const GetBotsRequested();
  @override
  List<Object> get props => [];
}

class SearchBotsRequested extends BotEvent {
  final List<Bot> bots;
  final String search;

  const SearchBotsRequested(this.bots, this.search);
  @override
  List<Object> get props => [bots, search];
}

class UpdateBotRequested extends BotEvent {
  final String name;
  final String description;
  final String id;

  const UpdateBotRequested(this.id, this.name, this.description);
  @override
  List<Object> get props => [id, name, description];
}

class DeleteBotRequested extends BotEvent {
  final String id;

  const DeleteBotRequested(this.id);
  @override
  List<Object> get props => [id];
}