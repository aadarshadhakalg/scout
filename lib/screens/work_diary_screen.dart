import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:scout/bloc/workdiary/workdiary_cubit.dart';
import 'package:scout/bloc/workdiary/workdiary_states.dart';
import 'package:scout/screens/work_diary_detail.dart';

import '../models/contract_model.dart';

class WorkDiaryView extends StatelessWidget {
  const WorkDiaryView({super.key, required this.contract});

  final Contract contract;

  @override
  Widget build(BuildContext context) {
    GetIt.I.get<WorkDiaryCubit>().fetchWorkDiary(contract);
    return Scaffold(
      appBar: AppBar(
        title: Text(contract.title),
      ),
      body: BlocBuilder<WorkDiaryCubit, WorkDiaryState>(
        bloc: GetIt.I.get<WorkDiaryCubit>(),
        builder: (context, state) {
          if (state is WorkDiaryFetchedState) {
            if (state.workdiaries.isEmpty) {
              return const Center(child: Text("Empty Record"));
            }
            return Column(
              children: [
                ListTile(
                  title: const Text("Work Diaries"),
                  trailing: Text(
                    "${Duration(
                      minutes: state.workdiaries
                          .map((e) => e.duration)
                          .reduce((value, element) => value + element),
                    ).toString().substring(0, 4)} Hours",
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.workdiaries.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => WorkDiaryDetail(
                                workDiary: state.workdiaries[index],
                              ),
                            ),
                          );
                        },
                        leading: Text(
                          "${index + 1} .",
                        ),
                        title: Text(
                          DateFormat.yMMMMEEEEd()
                              .format(state.workdiaries[index].startime),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
