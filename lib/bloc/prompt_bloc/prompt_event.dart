import 'package:bond/models/prompt.dart';
import 'package:equatable/equatable.dart';

abstract class PromptEvent extends Equatable {
  const PromptEvent();

  @override
  List<Object> get props => [];
}

class LoadPromptsEvent extends PromptEvent {
  final PromptCategory? category;
  final bool? isFavorite;
  final bool? isPublic;
  final int? limit;
  final int? offset;
  final String? query;

  const LoadPromptsEvent({
    this.category,
    this.isFavorite,
    this.isPublic,
    this.limit,
    this.offset,
    this.query,
  });

  @override
  List<Object> get props => [
        category ?? '',
        isFavorite ?? false,
        isPublic ?? false,
        limit ?? 0,
        offset ?? 10,
        query ?? '',
      ];
}

class CreatePromptEvent extends PromptEvent {
  final Prompt prompt;

  const CreatePromptEvent(this.prompt);

  @override
  List<Object> get props => [prompt];
}

class UpdatePromptEvent extends PromptEvent {
  final String id;
  final Prompt prompt;

  const UpdatePromptEvent(this.id, this.prompt);

  @override
  List<Object> get props => [id, prompt];
}

class DeletePromptEvent extends PromptEvent {
  final String id;

  const DeletePromptEvent(this.id);

  @override
  List<Object> get props => [id];
}

class ToggleFavoritePromptEvent extends PromptEvent {
  final String id;
  final bool isFavorite;

  const ToggleFavoritePromptEvent(this.id, this.isFavorite);

  @override
  List<Object> get props => [id, isFavorite];
}
