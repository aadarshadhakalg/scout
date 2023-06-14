part of 'tracker_bloc.dart';

sealed class TrackerEvent {}

class StartTRacking extends TrackerEvent {
  final Contract contract;

  StartTRacking(this.contract);
}

class StopTracking extends TrackerEvent {}

class SetMemo extends TrackerEvent {
  final String memo;

  SetMemo(this.memo);
}
