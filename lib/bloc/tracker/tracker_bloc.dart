import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scout/services/appwrite.dart';
import 'package:screenshotx/screenshotx.dart';
import 'package:uuid/uuid.dart';

import '../../models/contract_model.dart';

part 'tracker_events.dart';
part 'tracker_states.dart';

class TrackerBloc extends Bloc<TrackerEvent, TrackerState> {
  final AppwriteService appwriteService;

  TrackerBloc(this.appwriteService) : super(TrackerInitial()) {
    on<StartTRacking>(startTracking);
    on<StopTracking>(stopTracking);
    on<SetMemo>((event, emit) => _memo = event.memo);
  }

  bool _keepTracking = false;
  DateTime? _trackingStartTime;
  String? _memo;
  Document? _currentWorkDiary;

  Future<void> startTracking(StartTRacking event, emit) async {
    _keepTracking = true;
    _trackingStartTime = DateTime.now();

    _currentWorkDiary = await appwriteService.databases.createDocument(
      databaseId: "scout",
      collectionId: "workdiary",
      documentId: const Uuid().v4(),
      data: {
        "startime": _trackingStartTime!.toIso8601String(),
        "contractId": event.contract.$id,
      },
    );

    emit(TrackingState(
      lastCaptured: null,
      starttime: _trackingStartTime!,
      lastScreenshot: null,
    ));

    while (_keepTracking) {
      await Future.delayed(
        Duration(
          minutes: Random().nextInt(2) + 1,
        ),
      );
      if (_keepTracking) {
        DateTime currentTime = DateTime.now();
        Image? screenShot = await ScreenshotX().captureFullScreen();
        ByteData? imageByteData =
            await screenShot?.toByteData(format: ImageByteFormat.png);
        var screenshotId = const Uuid().v4();
        await appwriteService.storage.createFile(
          bucketId: "screenshots",
          fileId: screenshotId,
          file: InputFile.fromBytes(
            bytes: Uint8List.view(imageByteData!.buffer),
            filename: "$screenshotId.png",
          ),
        );

        await appwriteService.databases.createDocument(
          collectionId: "screenshots",
          databaseId: "scout",
          documentId: const Uuid().v4(),
          data: {
            "image": screenshotId,
            "workdiaryId": _currentWorkDiary!.$id,
            "memo": _memo,
          },
        );
        emit(
          TrackingState(
            starttime: _trackingStartTime!,
            lastScreenshot: screenShot,
            lastCaptured: currentTime,
          ),
        );
      }
    }

    emit(TrackerInitial());
  }

  Future<void> stopTracking(event, emit) async {
    _keepTracking = false;
    await appwriteService.databases.updateDocument(
      databaseId: "scout",
      collectionId: "workdiary",
      documentId: _currentWorkDiary!.$id,
      data: {
        "endtime": DateTime.now().toIso8601String(),
        "duration": DateTime.now().difference(_trackingStartTime!).inMinutes,
      },
    );
    emit(TrackerInitial());
  }
}
