import 'package:appwrite/appwrite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scout/bloc/screenshot/screenshot_state.dart';
import 'package:scout/models/screenshot_model.dart';
import 'package:scout/models/workdiary_model.dart';
import 'package:scout/services/appwrite.dart';

class ScreenshotCubit extends Cubit<ScreenshotState> {
  ScreenshotCubit(this.appwriteService) : super(InitialScreenShotState());

  final AppwriteService appwriteService;

  Future<void> fetchScreenshots(WorkDiary workDiary) async {
    emit(ScreenShotFetchingState());
    try {
      var workDiaries = await appwriteService.databases.listDocuments(
          databaseId: "scout",
          collectionId: "screenshots",
          queries: [
            Query.equal('workdiaryId', [workDiary.$id])
          ]);
      var allScreenshots = workDiaries.convertTo<Screenshot>(
        (p0) => Screenshot.fromJson(p0 as Map<String, dynamic>),
      );
      emit(
        ScreenShotFetchedState(allScreenshots),
      );
    } catch (e) {
      emit(ScreenShotErrorState(e.toString()));
    }
  }
}
