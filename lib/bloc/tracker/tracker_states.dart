part of 'tracker_bloc.dart';

sealed class TrackerState {}

class TrackerInitial extends TrackerState {}

class TrackingState extends TrackerState {
  final DateTime starttime;
  final Image? lastScreenshot;
  final DateTime? lastCaptured;

  TrackingState({
    required this.starttime,
    required this.lastScreenshot,
    required this.lastCaptured,
  });
}
