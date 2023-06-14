import 'package:appwrite/appwrite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scout/bloc/workdiary/workdiary_states.dart';
import 'package:scout/models/contract_model.dart';
import 'package:scout/models/workdiary_model.dart';
import 'package:scout/services/appwrite.dart';

class WorkDiaryCubit extends Cubit<WorkDiaryState> {
  WorkDiaryCubit(super.initialState, {required this.appwriteService});

  final AppwriteService appwriteService;

  Future<void> fetchWorkDiary(Contract contract) async {
    emit(WorkDiaryLoadingState());
    try {
      var workDiaries = await appwriteService.databases.listDocuments(
          databaseId: "scout",
          collectionId: "workdiary",
          queries: [
            Query.equal('contractId', [contract.$id])
          ]);
      var allDiaries = workDiaries.convertTo<WorkDiary>(
          (p0) => WorkDiary.fromJson(p0 as Map<String, dynamic>));
      emit(WorkDiaryFetchedState(allDiaries));
    } catch (e) {
      emit(WorkDiaryErrorState(e.toString()));
    }
  }
}
