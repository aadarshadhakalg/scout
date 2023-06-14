import 'package:scout/models/screenshot_model.dart';

sealed class ScreenshotState {}

class InitialScreenShotState extends ScreenshotState {}

class ScreenShotFetchedState extends ScreenshotState {
  final List<Screenshot> screenshots;

  ScreenShotFetchedState(this.screenshots);
}

class ScreenShotFetchingState extends ScreenshotState {}

class ScreenShotErrorState extends ScreenshotState {
  final String message;

  ScreenShotErrorState(this.message);
}
