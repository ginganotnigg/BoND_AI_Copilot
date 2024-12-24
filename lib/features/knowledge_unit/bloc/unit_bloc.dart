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
        final unitList = await unitApi.getUnitList(ev.knowledgeId);
        emit(UnitLoaded(unitList));
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<DeleteUnitEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.deleteUnit(ev.knowledgeId, ev.unitId);
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
        await unitApi.uploadLocalFile(ev.knowledgeId, ev.file);
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<UploadWebEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.uploadWeb(ev.knowledgeId, ev.unitName, ev.webUrl);
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    // Add ev handlers for Slack, Drive, Confluence uploads
    on<UploadSlackEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.uploadSlack(ev.knowledgeId, ev.unitName, ev.metadata);
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<UploadDriveEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.uploadDrive(ev.knowledgeId, ev.unitName, ev.metadata);
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });

    on<UploadConfluenceEvent>((ev, emit) async {
      try {
        final unitApi = UnitApi();
        await unitApi.uploadConfluence(ev.knowledgeId, ev.unitName, ev.metadata);
      } catch (e) {
        emit(UnitError(e.toString()));
      }
    });
  }
}
