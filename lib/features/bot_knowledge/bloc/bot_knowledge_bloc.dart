import 'package:bond/features/bot/bloc/bot_state.dart';
import 'package:bond/features/bot_knowledge/bloc/bot_knowledge_event.dart';
import 'package:bond/features/bot_knowledge/models/knowledge_in_bot.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../service/bot_knowledge_api.dart';
import 'bot_knowledge_state.dart';


class BotKnowledgeBloc extends Bloc<BotKnowledgeEvent, BotKnowledgeState> {
  final BotKnowledgeApi bkApi = BotKnowledgeApi();
  BotKnowledgeBloc() : super(BotKnowledgeInitial()) {
    on<GetKnowledgeInBotsRequested>((event, emit) async {
      emit(BotKnowledgeLoading());
      try {
        List<KnowledgeInBot> knowledge = await bkApi.getKnowledgeInBot(event.botId);
        if (knowledge.isEmpty) {
          emit(BotKnowledgeInitial());
        }
        else {
          emit(BotKnowledgeLoaded(knowledge));
          //
          emit(BotKnowledgeInitial());
        }
      } catch (e) {
        emit(BotKnowledgeError("Error Getting Knowledge For Bot ID: ${event.botId}"));
      }
    });

    on<RemoveKnowledgeFromBotRequested>((event, emit) async {
      emit(BotKnowledgeLoading());
      try {
        bool success = await bkApi.deleteKnowledgeFromBot(event.botId, event.knowledgeId);
        if (success) {
          emit(const BotKnowledgeModified("Knowledge Deleted From Bot"));
        }
        else {
          emit(const BotKnowledgeError("Error Removing Knowledge From Bot"));
        }
      } catch (e) {
        emit(const BotKnowledgeError("Error Removing Knowledge From Bot"));
      }
    });
  }
}

//IMPORT BLOC---------------------------------------------

class ImportKnowledgeBloc extends Bloc<ImportKnowledgeEvent, ImportKnowledgeState> {
  final BotKnowledgeApi bkApi = BotKnowledgeApi();
  ImportKnowledgeBloc() : super(KnowledgeInitial()) {
    on<GetAllKnowledgeRequested>((event, emit) async {
      emit(KnowledgeLoading());
      try {
        List<KnowledgeInBot> knowledge = await bkApi.getAllKnowledge();
        List<KnowledgeInBot> knowledgeInBot = await bkApi.getKnowledgeInBot(event.botId);
        //Remove duplicated
        final knowledgeInBotIds = knowledgeInBot.map((kib) => kib.id).toSet();
        knowledge.removeWhere((k) => knowledgeInBotIds.contains(k.id));
        //
        if (knowledge.isEmpty) {
          emit(KnowledgeInitial());
        }
        else {
          emit(KnowledgeLoaded(knowledge));
          emit(KnowledgeInitial());
        }
      } catch (e) {
        emit(const ImportKnowledgeError("Error Getting Knowledge"));
      }
    });

    on<AddKnowledgeToBotRequested>((event, emit) async {
      emit(KnowledgeLoading());
      try {
        bool success = await bkApi.addKnowledgeToBot(event.botId, event.knowledgeId);
        if (success) {
          emit(const KnowledgeModified("Knowledge Added To Bot"));
        }
        else {
          emit(const ImportKnowledgeError("Error Adding Knowledge To Bot"));
        }
      } catch (e) {
        emit(const ImportKnowledgeError("Error Adding Knowledge To Bot"));
      }
    });
  }
}
