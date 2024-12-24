import 'package:bloc/bloc.dart';
import 'package:bond/features/prompt/service/prompt_api.dart';
import 'prompt_event.dart';
import 'prompt_state.dart';

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  final PromptApi promptApi;
  int currentTabIndex = 0;

  PromptBloc(this.promptApi) : super(PromptInitial()) {
    on<LoadPromptsEvent>((event, emit) async {
      try {
        final prompts = await promptApi.getPrompts(
          category: event.category,
          isFavorite: event.isFavorite,
          isPublic: event.isPublic,
          limit: event.limit,
          offset: event.offset,
          query: event.query,
        );

        if (state is PromptLoaded && event.offset != 0) {
          final currentPrompts = (state as PromptLoaded).prompts;
          emit(PromptLoaded(currentPrompts + prompts));
        } else {
          emit(PromptLoaded(prompts));
        }
      } catch (e) {
        emit(PromptError(e.toString()));
      }
    });

    on<CreatePromptEvent>((event, emit) async {
      emit(PromptLoading());
      try {
        await promptApi.createPrompt(event.prompt);
        await _loadPromptsBasedOnTabIndex(emit);
      } catch (e) {
        emit(PromptError(e.toString()));
      }
    });

    on<UpdatePromptEvent>((event, emit) async {
      emit(PromptLoading());
      try {
        await promptApi.updatePrompt(event.id, event.prompt);
        await _loadPromptsBasedOnTabIndex(emit);
      } catch (e) {
        emit(PromptError(e.toString()));
      }
    });

    on<DeletePromptEvent>((event, emit) async {
      emit(PromptLoading());
      try {
        await promptApi.deletePrompt(event.id);
        await _loadPromptsBasedOnTabIndex(emit);
      } catch (e) {
        emit(PromptError(e.toString()));
      }
    });

    on<ToggleFavoritePromptEvent>((event, emit) async {
      emit(PromptLoading());
      try {
        await promptApi.toggleFavoritePrompt(event.id, event.isFavorite);
        await _loadPromptsBasedOnTabIndex(emit);
      } catch (e) {
        emit(PromptError(e.toString()));
      }
    });
  }

  Future<void> _loadPromptsBasedOnTabIndex(Emitter<PromptState> emit) async {
    try {
      final prompts = await promptApi.getPrompts(
        isPublic: currentTabIndex == 1 || currentTabIndex == 2,
        isFavorite: currentTabIndex == 2,
        limit: 10,
        offset: 0,
      );
      emit(PromptLoaded(prompts));
    } catch (e) {
      emit(PromptError(e.toString()));
    }
  }
}
