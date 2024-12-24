import 'package:bond/features/knowledge_base/service/knowledge_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'knowledge_event.dart';
import 'knowledge_state.dart';

class KnowledgeBloc extends Bloc<KnowledgeEvent, KnowledgeState> {
  KnowledgeBloc() : super(KnowledgeInitial()) {
    // Fetch knowledge
    on<FetchKnowledgeEvent>((ev, emit) async {
      emit(KnowledgeLoading());
      final knowledgeApi = KnowledgeApi();
      try {
        final knowledgeList = await knowledgeApi.getKnowledgeList();
        emit(KnowledgeLoaded(knowledgeList));
      } catch (e) {
        emit(KnowledgeError(e.toString()));
      }
    });

    // Add knowledge
    on<AddKnowledgeEvent>((ev, emit) async {
      emit(KnowledgeLoading());
      final knowledgeApi = KnowledgeApi();
      try {
        await knowledgeApi.addKnowledge(ev.title, ev.description);
        final updatedList = await knowledgeApi.getKnowledgeList();
        emit(KnowledgeLoaded(updatedList));
      } catch (e) {
        emit(KnowledgeError(e.toString()));
      }
    });

    // Edit knowledge
    on<EditKnowledgeEvent>((ev, emit) async {
      emit(KnowledgeLoading());
      final knowledgeApi = KnowledgeApi();
      try {
        await knowledgeApi.editKnowledge(ev.id, ev.title, ev.description);
        final updatedList = await knowledgeApi.getKnowledgeList();
        emit(KnowledgeLoaded(updatedList));
      } catch (e) {
        emit(KnowledgeError(e.toString()));
      }
    });

    // Delete knowledge
    on<DeleteKnowledgeEvent>((ev, emit) async {
      emit(KnowledgeLoading());
      final knowledgeApi = KnowledgeApi();
      try {
        await knowledgeApi.deleteKnowledge(ev.id);
        final updatedList = await knowledgeApi.getKnowledgeList();
        emit(KnowledgeLoaded(updatedList));
      } catch (e) {
        emit(KnowledgeError(e.toString()));
      }
    });

    // Search knowledge
    on<SearchKnowledgeEvent>((ev, emit) async {
      emit(KnowledgeLoading());
      final knowledgeApi = KnowledgeApi();
      try {
        final knowledgeList = await knowledgeApi.searchKnowledge(ev.query);
        emit(KnowledgeLoaded(knowledgeList));
      } catch (e) {
        emit(KnowledgeError(e.toString()));
      }
    });
  }
}
