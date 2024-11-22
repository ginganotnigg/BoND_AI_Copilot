import 'package:bond/models/prompt.dart';
import 'package:equatable/equatable.dart';

abstract class PromptState extends Equatable {
  const PromptState();

  @override
  List<Object> get props => [];
}

class PromptInitial extends PromptState {}

class PromptLoading extends PromptState {}

class PromptLoaded extends PromptState {
  final List<Prompt> prompts;

  const PromptLoaded(this.prompts);

  @override
  List<Object> get props => [prompts];
}

class PromptError extends PromptState {
  final String error;

  const PromptError(this.error);

  @override
  List<Object> get props => [error];
}
