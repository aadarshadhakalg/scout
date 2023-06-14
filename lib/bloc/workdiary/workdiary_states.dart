import 'package:scout/models/workdiary_model.dart';

sealed class WorkDiaryState {}

class WorkDiaryInitialState extends WorkDiaryState {}

class WorkDiaryLoadingState extends WorkDiaryState {}

class WorkDiaryFetchedState extends WorkDiaryState {
  final List<WorkDiary> workdiaries;

  WorkDiaryFetchedState(this.workdiaries);
}

class WorkDiaryErrorState extends WorkDiaryState {
  final String error;

  WorkDiaryErrorState(this.error);
}
