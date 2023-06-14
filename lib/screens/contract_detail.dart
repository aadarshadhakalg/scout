import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scout/bloc/contracts/contract_event.dart';
import 'package:scout/bloc/contracts/contracts_bloc.dart';
import 'package:scout/screens/work_diary_screen.dart';

import '../models/contract_model.dart';

class ContractDetail extends StatelessWidget {
  const ContractDetail({
    super.key,
    required this.contract,
    this.isReceiver = false,
    this.isSender = false,
  });

  final Contract contract;
  final bool isSender;
  final bool isReceiver;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contract.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: const Text("ID :"),
              trailing: Text(contract.$id),
            ),
            ListTile(
              title: const Text("Description :"),
              subtitle: Text(contract.description ?? "None"),
            ),
            ListTile(
              title: const Text("Status :"),
              trailing: Text(contract.status.name.toUpperCase()),
            ),
            ListTile(
              title: const Text("Employer Name :"),
              trailing: Text(contract.employerName ?? contract.employerId),
            ),
            ListTile(
              title: const Text("Employer Phone :"),
              trailing: Text(contract.employerId),
            ),
            ListTile(
              title: const Text("Employee Phone :"),
              trailing: Text(contract.employeeId),
            ),
            const SizedBox(
              height: 20,
            ),
            if (isReceiver && contract.status == Status.pending)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        GetIt.I.get<ContractBloc>().add(
                              AcceptContract(contract),
                            );
                        Navigator.pop(context);
                      },
                      child: const Text("Accept"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        GetIt.I.get<ContractBloc>().add(
                              DeclineContract(contract),
                            );
                        Navigator.pop(context);
                      },
                      child: const Text("Decline"),
                    )
                  ],
                ),
              ),
            if (isSender)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (contract.status == Status.active)
                      ElevatedButton(
                        onPressed: () {
                          GetIt.I.get<ContractBloc>().add(
                                ToggleHoldContract(contract),
                              );
                          Navigator.pop(context);
                        },
                        child: Text(contract.status == Status.onhold
                            ? "UnHold"
                            : "Hold"),
                      ),
                    if (contract.status != Status.done)
                      ElevatedButton(
                        onPressed: () {
                          GetIt.I.get<ContractBloc>().add(
                                EndContract(contract),
                              );
                          Navigator.pop(context);
                        },
                        child: const Text("End"),
                      )
                  ],
                ),
              ),
            if (isSender)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => WorkDiaryView(contract: contract),
                    ),
                  );
                },
                child: const Text("View Work Diary"),
              )
          ],
        ),
      ),
    );
  }
}
