abstract class KnowledgeEvent {
  List<Object?> get props => [];
}

class FetchKnowledgeEvent extends KnowledgeEvent {}

class AddKnowledgeEvent extends KnowledgeEvent {
  final String title;
  final String description;

  AddKnowledgeEvent(this.title, this.description);

  @override
  List<Object> get props => [title, description];
}

class EditKnowledgeEvent extends KnowledgeEvent {
  final String id;
  final String title;
  final String description;

  EditKnowledgeEvent(this.id, this.title, this.description);

  @override
  List<Object> get props => [id, title, description];
}

class DeleteKnowledgeEvent extends KnowledgeEvent {
  final String id;

  DeleteKnowledgeEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SearchKnowledgeEvent extends KnowledgeEvent {
  final String query;

  SearchKnowledgeEvent(this.query);

  @override
  List<Object> get props => [query];
}
