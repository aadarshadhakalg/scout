import 'dart:typed_data';

import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:scout/bloc/screenshot/screenshot_cubit.dart';
import 'package:scout/bloc/screenshot/screenshot_state.dart';
import 'package:scout/models/workdiary_model.dart';
import 'package:scout/services/appwrite.dart';

class WorkDiaryDetail extends StatelessWidget {
  const WorkDiaryDetail({super.key, required this.workDiary});

  final WorkDiary workDiary;

  @override
  Widget build(BuildContext context) {
    GetIt.I.get<ScreenshotCubit>().fetchScreenshots(workDiary);
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat.yMMMMEEEEd().format(workDiary.startime)),
      ),
      body: BlocBuilder<ScreenshotCubit, ScreenshotState>(
        bloc: GetIt.I.get<ScreenshotCubit>(),
        builder: (context, state) {
          if (state is ScreenShotFetchedState) {
            return ListView.builder(
              itemCount: state.screenshots.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Uint8List>(
                  future: AppwriteService().storage.getFileDownload(
                      bucketId: "screenshots",
                      fileId: state.screenshots[index].image),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                        title: Text(state.screenshots[index].memo ?? "No Memo"),
                        subtitle: Image.memory(
                          snapshot.data!,
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
