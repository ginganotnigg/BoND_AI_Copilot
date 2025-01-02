import 'package:bond/features/knowledge_unit/models/unit_list.dart';

abstract class UnitState {}

class UnitInitial extends UnitState {}

class UnitLoading extends UnitState {}

class UnitLoaded extends UnitState {
  final UnitList unitList;

  UnitLoaded(this.unitList);
}

class UnitError extends UnitState {
  final String error;
  UnitError(this.error);
}
