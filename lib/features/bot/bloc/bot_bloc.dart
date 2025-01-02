
import 'package:bond/features/bot/bloc/bot_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/helpers/auth_helper.dart';
import '../models/bot.dart';
import '../service/bot_api.dart';
import 'bot_event.dart';


class BotBloc extends Bloc<BotEvent, BotState> {
  final BotApi botApi = BotApi();
  BotBloc() : super(BotInitial()) {
    on<CreateBotRequested>((event, emit) async {
      emit(BotLoading());
      try {
        Bot bot = await botApi.createBot(event.name, event.description);
        if (bot.id.isEmpty) {
          emit(BotInitial());
        }
        else {
          emit(BotModified("Bot ${bot.name} Created"));
        }
      } catch (e) {
        emit(const BotError("Error Creating Your Bot"));
      }
    });
    on<GetBotsRequested>((event, emit) async {
      emit(BotLoading());
      try {
        List<Bot> bots = await botApi.getBots();
        if (bots.isEmpty) {
          emit(BotInitial());
        }
        else {
          emit(BotLoaded(bots));
          emit(BotInitial());
        }
      } catch (e) {
        emit(const BotError("Error Getting Your Bots"));
      }
    });
    on<SearchBotsRequested>((event, emit) async {
      emit(BotLoading());
      try {
        final query = event.search.trim().toLowerCase();
        if (query.isEmpty) {
          List<Bot> filteredBots = event.bots;
          emit(BotSearched(filteredBots));
        } else {
          List<Bot> filteredBots = event.bots.where((bot) {
            return bot.name.toLowerCase().contains(query) ||
                bot.description.toLowerCase().contains(query);
          }).toList();
          emit(BotSearched(filteredBots));
        }
        emit(BotInitial());
      } catch (e) {
        emit(const BotError("Error"));
      }
    });
    on<UpdateBotRequested>((event, emit) async {
      emit(BotLoading());
      try {
        Bot bot = await botApi.updateBot(event.id, event.name, event.description);
        if (bot.id.isEmpty) {
          emit(BotInitial());
        }
        else {
          emit(BotModified("Bot ${bot.name} Updated"));
        }
      } catch (e) {
        emit(const BotError("Error Updating Your Bot"));
      }
    });
    on<DeleteBotRequested>((event, emit) async {
      emit(BotLoading());
      try {
        bool success = await botApi.deleteBot(event.id);
        if (success) {
          emit(const BotModified("Bot Deleted"));
        }
        else {
          emit(const BotError("Error Deleting Your Bot"));
        }
      } catch (e) {
        emit(const BotError("Error Deleting Your Bot"));
      }
    });
  }
}