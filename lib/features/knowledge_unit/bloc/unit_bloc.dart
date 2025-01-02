import 'package:bond/features/knowledge_unit/service/unit_api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'unit_event.dart';
import 'unit_state.dart';

class UnitBloc extends Bloc<UnitEvent, UnitState> {
  UnitBloc() : super(UnitInitial()) {
    on<GetUnitListEvent>((ev, emit) async {
      emit(UnitLoading());
      final unitApi = UnitApi();
      try {
        final unitList = await unitApi.getUnitList(ev.knowledge.id);
        emit(UnitLoaded(unitList));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<DeleteUnitEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.deleteUnit(ev.knowledge.id, ev.unitId);
        add(GetUnitListEvent(ev.knowledge));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<UpdateStatusUnitEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.updateStatusUnit(ev.unitId, ev.status);
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<UploadLocalFileEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.uploadLocalFile(ev.knowledge.id, ev.file);
        add(GetUnitListEvent(ev.knowledge));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<UploadWebEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.uploadWeb(ev.knowledge.id, ev.unitName, ev.webUrl);
        add(GetUnitListEvent(ev.knowledge));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    // Add ev handlers for Slack, Drive, Confluence uploads
    on<UploadSlackEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.uploadSlack(ev.knowledge.id, ev.unitName, ev.metadata);
        add(GetUnitListEvent(ev.knowledge));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<UploadDriveEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.uploadDrive(ev.knowledge.id, ev.unitName, ev.metadata);
        add(GetUnitListEvent(ev.knowledge));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<UploadConfluenceEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.uploadConfluence(
            ev.knowledge.id, ev.unitName, ev.metadata);
        add(GetUnitListEvent(ev.knowledge));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<UpdateCurrentKnowledgeEvent>((ev, emit) async {
      if (state is UnitLoaded) {
        final unitList = (state as UnitLoaded).unitList;
        emit(UnitLoaded(unitList));
      }
    });

    on<SearchUnitEvent>((ev, emit) async {
      emit(UnitLoading());
      final unitApi = UnitApi();
      try {
        final unitList = await unitApi.searchUnit(ev.knowledge.id, ev.query);
        emit(UnitLoaded(unitList));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });
  }
}
