import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:scout/bloc/contracts/contract_states.dart';
import 'package:scout/bloc/contracts/contracts_bloc.dart';
import 'package:scout/screens/contract_detail.dart';

import '../bloc/authentication/authentication_cubit.dart';
import '../models/contract_model.dart';
import '../widgets/animated_bs.dart';
import 'create_contract.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(
    BuildContext context,
  ) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(GetIt.I.get<AuthenticationCubit>().user!.name),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Sent",
              ),
              Tab(
                text: "Received",
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey.shade300,
          foregroundColor: Colors.black,
          tooltip: "Create Contract",
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) {
                return AnimatedBottomSheet(
                  buildContext: context,
                  title: 'Create Contract',
                  child: CreateContract(),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            BlocBuilder<ContractBloc, ContractState>(
              bloc: GetIt.I.get<ContractBloc>(),
              builder: (context, state) {
                if (state is ContractsFetchedState) {
                  var sents = state.contracts
                      .where(
                        (element) =>
                            element.employerId ==
                            GetIt.I.get<AuthenticationCubit>().user!.phone,
                      )
                      .toList();
                  return ListView.builder(
                    itemCount: sents.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ContractDetail(
                                contract: sents[index],
                                isSender: true,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: sents[index].status == Status.onhold
                              ? Colors.amber
                              : sents[index].status == Status.declined
                                  ? Colors.red
                                  : sents[index].status == Status.done
                                      ? Colors.green
                                      : Colors.blue,
                          child: Text(
                            sents[index]
                                .status
                                .name
                                .characters
                                .first
                                .toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        title: Text(sents[index].title),
                        subtitle: FutureBuilder<Object>(
                          future: null,
                          builder: (context, snapshot) {
                            return Text(
                              sents[index].employerName ??
                                  sents[index].employerId,
                            );
                          },
                        ),
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
            BlocBuilder<ContractBloc, ContractState>(
              bloc: GetIt.I.get<ContractBloc>(),
              builder: (context, state) {
                if (state is ContractsFetchedState) {
                  var received = state.contracts
                      .where(
                        (element) =>
                            element.employeeId ==
                            GetIt.I.get<AuthenticationCubit>().user!.phone,
                      )
                      .toList();
                  return ListView.builder(
                    itemCount: received.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ContractDetail(
                                contract: received[index],
                                isReceiver: true,
                              ),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor:
                              received[index].status == Status.onhold
                                  ? Colors.amber
                                  : received[index].status == Status.declined
                                      ? Colors.red
                                      : received[index].status == Status.done
                                          ? Colors.green
                                          : Colors.blue,
                          child: Text(
                            received[index]
                                .status
                                .name
                                .characters
                                .first
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(received[index].title),
                        subtitle: FutureBuilder<Object>(
                          future: null,
                          builder: (context, snapshot) {
                            return Text(
                              received[index].employerName ??
                                  received[index].employerId,
                            );
                          },
                        ),
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
          ],
        ),
      ),
    );
  }
}
